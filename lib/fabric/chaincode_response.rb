module Fabric
  class ChaincodeResponse
    attr_reader :proposal, :proposal_responses, :responses

    def initialize(attrs)
      @proposal = attrs[:proposal]
      @proposal_responses = attrs[:proposal_responses].compact
      @responses = proposal_responses.map(&:response)
    end

    def success?
      success_responses.any?
    end

    def success_responses
      @success_responses ||= responses.select { |response| response.status == 200 }
    end

    def failure_response
      @failure_response ||= responses.find { |response| response.status == 500 }
    end

    def tx_id
      proposal.tx_id
    end

    def tx_timestamp
      proposal.tx_timestamp
    end

    def tx_unix_timestamp
      (tx_timestamp.seconds * 1000 + tx_timestamp.nanos / 10**6).to_i
    end

    def payload
      success_responses.first&.payload
    end

    def validate!
      return if success?

      raise NetworkOfflineError if proposal_responses.empty?

      raise ErrorFactory.create failure_response.message
    end
  end
end
