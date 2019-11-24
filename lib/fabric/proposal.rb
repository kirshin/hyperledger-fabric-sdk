module Fabric
  class Proposal
    attr_reader :identity, :request

    def initialize(identity, request = {})
      @identity = identity
      @request = request

      assign_tx request[:transaction_info] if request[:transaction_info]
    end

    def crypto_suite
      identity.crypto_suite
    end

    def nonce
      @nonce ||= crypto_suite.generate_nonce
    end

    def channel_id
      request[:channel_id]
    end

    def chaincode_id
      request[:chaincode_id]
    end

    def args
      request[:args].compact.map &:to_s
    end

    def transient
      request[:transient] || {}
    end

    def transaction_id
      request[:transaction_id]
    end

    def tx_id
      @tx_id ||= crypto_suite.hexdigest(nonce + identity.serialize)
    end

    def proposal
      @proposal ||= Protos::Proposal.new header: header.to_proto,
                                         payload: chaincode_proposal.to_proto
    end

    def signed_proposal
      proposal_bytes = proposal.to_proto
      signature = identity.sign proposal_bytes

      Protos::SignedProposal.new proposal_bytes: proposal_bytes, signature: signature
    end

    def header
      Common::Header.new channel_header: channel_header.to_proto,
                         signature_header: signature_header.to_proto
    end

    def channel_header
      Common::ChannelHeader.new type: Common::HeaderType::ENDORSER_TRANSACTION,
                                channel_id: channel_id, tx_id: tx_id,
                                extension: channel_header_extension.to_proto,
                                timestamp: tx_timestamp,
                                version: Constants::CHANNEL_HEADER_VERSION
    end

    def channel_header_extension
      id = Protos::ChaincodeID.new name: chaincode_id

      Protos::ChaincodeHeaderExtension.new chaincode_id: id
    end

    def tx_timestamp
      now = Time.now

      @tx_timestamp ||= Google::Protobuf::Timestamp.new seconds: now.to_i, nanos: now.nsec
    end

    def signature_header
      Common::SignatureHeader.new creator: identity.serialize, nonce: nonce
    end

    def chaincode_proposal
      id = Protos::ChaincodeID.new name: chaincode_id
      chaincode_input = Protos::ChaincodeInput.new args: args
      chaincode_spec = Protos::ChaincodeSpec.new type: Protos::ChaincodeSpec::Type::NODE,
                                                 chaincode_id: id,
                                                 input: chaincode_input
      input = Protos::ChaincodeInvocationSpec.new chaincode_spec: chaincode_spec

      Protos::ChaincodeProposalPayload.new input: input.to_proto, TransientMap: transient
    end

    private

    def assign_tx(transaction_info)
      @tx_id = transaction_info[:tx_id]
      @nonce = crypto_suite.decode_hex transaction_info[:nonce_hex]
    end
  end
end
