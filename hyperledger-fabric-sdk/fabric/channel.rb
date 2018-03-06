require 'peer/transaction_pb'

module Fabric
  class Channel
    attr_reader :identity_context, :name, :peers, :orderers

    def initialize(args)
      @identity_context = args[:identity_context]
      @name = args[:name]
      @peers = args[:peers] || []
      @orderers = args[:orderers] || []
    end

    def query_by_chaincode(request)
      request[:targets] ||= peers
      request[:transaction] = TransactionID.new identity_context

      PeerEndorser.send_transaction_proposal request, name, identity_context
    end

    def send_transaction(request, &block)
      header = Common::Header.decode request[:proposal].header
      chaincode_action_payload = build_chaincode_action request

      transaction_action = Protos::TransactionAction.new header: header.signature_header,
                                                         payload: chaincode_action_payload.to_proto
      transaction = Protos::Transaction.new actions: [transaction_action]

      payload = Common::Payload.new header: header,
                                    data: transaction.to_proto

      envelope = Common::Envelope.new signature: identity_context.identity.sign(payload.to_proto),
                                      payload: payload.to_proto

      orderers.first.send_broadcast envelope, &block
    end

    private

      def build_chaincode_action(request)
        responses = request[:responses].select { |response| response.response.status == 200 }
        endorsements = responses.map { |response| response.endorsement }
        chaincode_endorser_action =
          Protos::ChaincodeEndorsedAction.new proposal_response_payload: responses.first.payload,
                                              endorsements: endorsements

        payload = Protos::ChaincodeProposalPayload.decode request[:proposal].payload
        payload_no_trans = Protos::ChaincodeProposalPayload.new input: payload.input

        Protos::ChaincodeActionPayload.new action: chaincode_endorser_action,
                                           chaincode_proposal_payload: payload_no_trans.to_proto
      end
  end
end
