require 'peer/peer_services_pb'

module Fabric
  class PeerEndorser
    def self.send_transaction_proposal(request, channel_id, identity_context)
      args = request[:args].unshift request[:function]

      transaction = request[:transaction]

      channel_header = build_channel_header Common::HeaderType::ENDORSER_TRANSACTION,
                                            channel_id, transaction.id, request[:chaincode_id]
      header = build_header channel_header, identity_context.identity, transaction.nonce
      proposal = build_proposal header, request[:chaincode_id], args
      signed_proposal = sign_proposal identity_context.identity, proposal

      responses = send_peers_process_proposal request[:targets], signed_proposal

      { responses: responses, proposal: proposal, header: header }
    end

    private

      def self.build_header(channel_header, identity, nonce)
        signature_header = Common::SignatureHeader.new creator: identity.serialize,
                                                       nonce: nonce

        Common::Header.new channel_header: channel_header.to_proto,
                           signature_header: signature_header.to_proto
      end

      def self.build_channel_header(type, channel_id, tx_id, chaincode_id)
        attrs = { type: type, channel_id: channel_id, tx_id: tx_id }
        attrs[:extension] = build_channel_header_extension(chaincode_id).to_proto if chaincode_id
        attrs[:timestamp] = build_current_timestamp
        attrs[:version] = Constants::CHANNEL_HEADER_VERSION

        Common::ChannelHeader.new attrs
      end

      def self.build_channel_header_extension(chaincode_id)
        id = Protos::ChaincodeID.new name: chaincode_id

        Protos::ChaincodeHeaderExtension.new chaincode_id: id
      end

      def self.build_current_timestamp
        now = Time.current

        Google::Protobuf::Timestamp.new seconds: now.to_i, nanos: now.sec
      end

      def self.build_proposal(header, chaincode_id, args)
        chaincode_proposal = build_chaincode_proposal chaincode_id, args

        Protos::Proposal.new header: header.to_proto,
                             payload: chaincode_proposal.to_proto
      end

      def self.build_chaincode_proposal(chaincode_id, args)
        id = Protos::ChaincodeID.new name: chaincode_id
        chaincode_input = Protos::ChaincodeInput.new args: args
        chaincode_spec = Protos::ChaincodeSpec.new type: Protos::ChaincodeSpec::Type::GOLANG,
                                                   chaincode_id: id,
                                                   input: chaincode_input
        chaincode_invocation_spec =
          Protos::ChaincodeInvocationSpec.new chaincode_spec: chaincode_spec

        Protos::ChaincodeProposalPayload.new input: chaincode_invocation_spec.to_proto
      end

      def self.sign_proposal(identity, proposal)
        proposal_bytes = proposal.to_proto
        signature = identity.sign(proposal_bytes)

        Protos::SignedProposal.new proposal_bytes: proposal_bytes,
                                   signature: signature
      end

      def self.send_peers_process_proposal(peers, proposal)
        peers.map do |peer|
          peer.send_process_proposal(proposal)
        end
      end
  end
end
