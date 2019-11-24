require 'orderer/ab_services_pb.rb'

module Fabric
  class Orderer < ClientStub
    def client
      @client ||= ::Orderer::AtomicBroadcast::Stub.new host, creds, options
    end

    def send_broadcast(envelope)
      logging :send_broadcast_request, envelope.to_h

      client.broadcast([envelope]).each do |response|
        logging :send_broadcast_response, response.to_h

        raise OrdererError response.message unless response.status == :SUCCESS

        yield response if block_given?
      end
    end
  end
end
