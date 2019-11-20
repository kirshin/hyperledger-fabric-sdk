module Fabric
  class ErrorFactory
    CHAINCODE_ERROR_MESSAGE_PREFIX = 'transaction returned with failure:'.freeze

    def self.create(message)
      if message.start_with? CHAINCODE_ERROR_MESSAGE_PREFIX
        ChaincodeError.new message.gsub(CHAINCODE_ERROR_MESSAGE_PREFIX, '')
      else
        UnknownError.new message
      end
    end
  end

  class Error < StandardError
    attr_reader :code, :errors

    def initialize(message, code = 0, errors = {})
      super message

      @code = code
      @errors = errors
    end

    def response
      Hashie::Mash.new success: false,
                       code: code,
                       result: {},
                       message: message,
                       errors: errors
    end
  end

  class ChaincodeError < Fabric::Error
    def initialize(message)
      response = Hashie::Mash.new JSON.parse(message)

      super response.message, response.code, response.errors
    end
  end

  class OrdererError < Fabric::Error; end

  class TransactionError < Fabric::Error
    def initialize(status)
      super "Transaction failed (#{status})", "TX_STATUS_#{status}"
    end
  end

  class NetworkOfflineError < Fabric::Error; end

  class UnknownError < Fabric::Error; end
end
