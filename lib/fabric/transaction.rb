require 'peer/transaction_pb'

module Fabric
  class Transaction
    attr_reader :identity, :request

    def initialize(identity, request = {})
      @identity = identity
      @request = request
    end

    def tx_id
      proposal.tx_id
    end

    def proposal
      request[:proposal]
    end

    def responses
      request[:responses]
    end

    def endorsements
      responses.map(&:endorsement)
    end

    def header
      proposal.header
    end

    def transaction
      transaction_action = Protos::TransactionAction.new header: proposal.signature_header.to_proto,
                                                         payload: chaincode_action.to_proto
      Protos::Transaction.new actions: [transaction_action]
    end

    def chaincode_action
      action =
        Protos::ChaincodeEndorsedAction.new proposal_response_payload: responses.first.payload,
                                            endorsements: endorsements

      payload = Protos::ChaincodeProposalPayload.decode proposal.proposal.payload
      payload_no_trans = Protos::ChaincodeProposalPayload.new input: payload.input

      Protos::ChaincodeActionPayload.new action: action,
                                         chaincode_proposal_payload: payload_no_trans.to_proto
    end
  end
end
