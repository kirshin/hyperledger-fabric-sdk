require 'peer/query_pb'

module Fabric
  class Peer
    attr_reader :url, :opts, :identity_context, :client

    def initialize(args)
      @url = args[:url]
      @opts = args[:opts]
      @identity_context = args[:identity_context]
      @client = Protos::Endorser::Stub.new url, :this_channel_is_insecure
    end

    def send_process_proposal(proposal)
      client.process_proposal proposal
    end

    def query_channels
      request = {
        targets: [self],
        chaincode_id: Constants::CSCC,
        transaction: TransactionID.new(identity_context),
        function: Constants::FUNC_GET_CHANNELS,
        args: []
      }

      responses = PeerEndorser.send_transaction_proposal request, '', identity_context
      response = responses.first

      Protos::ChannelQueryResponse.decode response.response.payload
    end

    def query_config_block(channel_id)
      request = {
        targets: [self],
        chaincode_id: Constants::CSCC,
        transaction: TransactionID.new(identity_context),
        function: Constants::FUNC_GET_CONFIG_BLOCK,
        args: [channel_id]
      }

      responses = PeerEndorser.send_transaction_proposal request, '', identity_context
      proposal_response = responses.first

      extract_config_enveloper proposal_response
    end

    private

      def extract_config_enveloper(proposal_response)
        block = Common::Block.decode proposal_response.response.payload
        envelope = Common::Envelope.decode block.data.data.first
        payload = Common::Payload.decode envelope.payload

        Common::ConfigEnvelope.decode payload.data
      end
  end
end
