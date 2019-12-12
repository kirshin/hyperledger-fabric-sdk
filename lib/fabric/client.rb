module Fabric
  class Client
    attr_reader :identity, :orderers, :peers, :event_hubs, :logger

    def initialize(opts = {})
      options = Fabric.options.merge opts

      @logger = FabricLogger.new options[:logger], options[:logger_filters]
      @identity = options[:identity]
    end

    def register_peer(options, extra_options = {})
      @peers ||= []

      options = { host: options } if options.is_a?(String)
      extra_options.merge!(options)
      extra_options.merge!(logger: logger)

      @peers << Peer.new(extra_options[:host], extra_options[:creds], extra_options)
    end

    def register_orderer(options, extra_options = {})
      @orderers ||= []

      options = { host: options } if options.is_a?(String)
      extra_options.merge!(options)
      extra_options.merge!(logger: logger)

      @orderers << Orderer.new(extra_options[:host], extra_options[:creds], extra_options)
    end

    def register_event_hub(options, extra_options = {})
      @event_hubs ||= []

      options = { host: options } if options.is_a?(String)
      extra_options.merge!(options)
      extra_options.merge!(logger: logger)

      @event_hubs << EventHub.new(extra_options[:host], extra_options[:creds], extra_options)
    end

    def query(request = {})
      logging __method__, request

      proposal = Proposal.new identity, request

      send_query(proposal) { |response| parse_chaincode_response response.response }
    end

    def invoke(request = {})
      logging __method__, request

      proposal = Proposal.new identity, request

      responses = send_query(proposal) { |response| parse_peer_response response }

      transaction = Transaction.new identity, proposal: proposal, responses: responses

      send_transaction(transaction) { |response| parse_orderer_response response }

      responses.map { |response| parse_chaincode_response response.response }

      transaction
    end

    private

    def send_query(proposal, &block)
      peers.map do |peer|
        peer_response = peer.send_process_proposal(proposal.signed_proposal)

        block ? yield(peer_response) : peer_response
      end
    end

    def send_transaction(transaction, &block)
      payload = Common::Payload.new header: transaction.header,
                                    data: transaction.transaction.to_proto

      envelope = Common::Envelope.new signature: identity.sign(payload.to_proto),
                                      payload: payload.to_proto

      orderers.each { |orderer| orderer.send_broadcast envelope, &block }
    end

    def parse_chaincode_response(response)
      case response.status
      when 200 then response.payload
      when 500 then raise ErrorFactory.create(response.message)
      end
    end

    def parse_peer_response(response)
      case response.response.status
      when 200 then response
      when 500 then raise ErrorFactory.create(response.response.message)
      end
    end

    def parse_orderer_response(response)
      raise OrdererError response.message unless response.status == :SUCCESS

      response
    end

    def logging(section, message = {})
      logger.info section.to_s.upcase,
                  message.to_s
    end
  end
end
