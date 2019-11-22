module Fabric
  class Client
    attr_reader :identity, :crypto_suite,
                :orderers, :peers, :logger

    def initialize(opts = {})
      options = Fabric.options.merge opts

      @logger = Logger.new options[:logger], options[:logger_filters]
      @identity = options[:identity]
      @crypto_suite = options[:crypto_suite]
    end

    def register_peer(url, opts = {})
      @peers ||= []

      @peers << Peer.new(url: url, opts: opts, logger: logger)
    end

    def register_orderer(url, opts = {})
      @orderers ||= []

      @orderers << Orderer.new(url: url, opts: opts, logger: logger)
    end

    def query(request = {})
      logging __method__, request

      proposal = Proposal.new crypto_suite, identity, request

      send_query(proposal) { |response| parse_chaincode_response response.response }
    end

    def invoke(request = {})
      logging __method__, request

      proposal = Proposal.new crypto_suite, identity, request

      responses = send_query(proposal) { |response| parse_peer_response response }

      transaction = Transaction.new crypto_suite, identity, proposal: proposal,
                                                            responses: responses

      send_transaction(transaction) { |response| parse_orderer_response response }

      responses.map { |response| parse_chaincode_response response.response }
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
      logger.info section.to_s.upcase.colorize(:yellow),
                  message.to_s.colorize(:blue)
    end
  end
end
