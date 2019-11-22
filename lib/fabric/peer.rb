require 'peer/peer_services_pb'

module Fabric
  class Peer
    attr_reader :url, :channel, :logger

    def initialize(opts)
      @url = opts[:url]
      @logger = opts[:logger]
      channel_creds = opts[:channel_creds] || :this_channel_is_insecure

      @channel = Protos::Endorser::Stub.new url, channel_creds
    end

    def send_process_proposal(proposal)
      logging :send_process_proposal_request, proposal.to_h

      response = channel.process_proposal proposal

      logging :send_process_proposal_response, response.to_h

      response
    end

    private

    def logging(section, message)
      logger.debug section.to_s.upcase.colorize(:yellow),
                   url.colorize(:red),
                   message.to_s.colorize(:blue)
    end
  end
end
