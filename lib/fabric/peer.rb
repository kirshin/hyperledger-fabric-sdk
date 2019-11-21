require 'peer/peer_services_pb'

module Fabric
  class Peer
    attr_reader :url, :opts, :client, :logger

    def initialize(args)
      @url = args[:url]
      @opts = args[:opts]
      @logger = args[:logger]

      @client = Protos::Endorser::Stub.new url, :this_channel_is_insecure
    end

    def send_process_proposal(proposal)
      logging :send_process_proposal_request, proposal.to_h

      response = client.process_proposal proposal

      logging :send_process_proposal_response, response.to_h

      response
    end

    def create_event_hub
      EventHub.new url: url, opts: opts, logger: logger
    end

    private

    def logging(section, message)
      logger.debug section.to_s.upcase.colorize(:yellow),
                   url.colorize(:red),
                   message.to_s.colorize(:blue)
    end
  end
end
