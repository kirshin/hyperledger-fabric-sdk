require 'orderer/ab_services_pb.rb'

module Fabric
  class Orderer
    attr_reader :url, :opts, :client

    def initialize(args)
      @url = args[:url]
      @opts = args[:opts]
      @client = ::Orderer::AtomicBroadcast::Stub.new url, :this_channel_is_insecure
    end

    def send_broadcast(envelope)
      client.broadcast([envelope]) do |response|
        yield response if block_given?
      end
    end
  end
end
