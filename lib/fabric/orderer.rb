require 'orderer/ab_services_pb.rb'

module Fabric
  class Orderer
    attr_reader :url, :channel, :logger

    def initialize(opts)
      @url = opts[:url]
      @logger = opts[:logger]
      channel_creds = opts[:channel_creds] || :this_channel_is_insecure

      @channel = ::Orderer::AtomicBroadcast::Stub.new url, channel_creds
    end

    def send_broadcast(envelope)
      logging :send_broadcast_request, envelope.to_h

      channel.broadcast([envelope]).each do |response|
        logging :send_broadcast_response, response.to_h

        raise OrdererError response.message unless response.status == :SUCCESS

        yield response if block_given?
      end
    end

    private

    def logging(section, message)
      logger.debug section.to_s.upcase.colorize(:yellow),
                   url.colorize(:red),
                   message.to_s.colorize(:blue)
    end
  end
end
