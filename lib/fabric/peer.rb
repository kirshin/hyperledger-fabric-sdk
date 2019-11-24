require 'peer/peer_services_pb'

module Fabric
  class Peer < ClientStub
    def client
      @client ||= Protos::Endorser::Stub.new(host, creds, options)
    end

    def send_process_proposal(proposal)
      logging :send_process_proposal_request, proposal.to_h

      response = client.process_proposal proposal

      logging :send_process_proposal_response, response.to_h

      response
    end
  end
end
