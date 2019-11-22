module Fabric
  class Channel
    attr_reader :identity, :crypto_suite, :channel_id,
                :orderers, :peers, :logger

    def initialize(opts = {})
      options = Fabric.options.merge opts

      @channel_id = options[:channel_id]
      @logger = FabricLogger.new options[:logger], options[:logger_filters]
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
      request[:channel_id] = channel_id

      logging __method__, request

      proposal = Proposal.new crypto_suite, identity, request
      proposal_responses = peers.map { |peer| peer.send_process_proposal(proposal.signed_proposal) }

      chaincode_response = ChaincodeResponse.new proposal: proposal,
                                                 proposal_responses: proposal_responses

      chaincode_response.validate!

      chaincode_response
    end

    def invoke(chaincode_response)
      transaction = Transaction.new crypto_suite,
                                    identity,
                                    proposal: chaincode_response.proposal,
                                    responses: chaincode_response.proposal_responses

      send_transaction transaction

      chaincode_response
    end

    def create_transaction_info
      TransactionInfo.new crypto_suite, identity
    end

    private

    def send_transaction(transaction)
      payload = Common::Payload.new header: transaction.header,
                                    data: transaction.transaction.to_proto

      envelope = Common::Envelope.new signature: identity.sign(payload.to_proto),
                                      payload: payload.to_proto

      orderers.each { |orderer| orderer.send_broadcast envelope }
    end

    def logging(section, message = {})
      logger.info section.to_s.upcase.colorize(:yellow),
                  message.to_s.colorize(:blue)
    end
  end
end
