require File.expand_path('../connection', __FILE__)
require File.expand_path('../request', __FILE__)

module FabricCA
  class Client
    include Connection
    include Request

    attr_accessor *Configuration::VALID_OPTIONS_KEYS

    def initialize(options = {})
      options = FabricCA.options.merge(options)

      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    def config
      conf = {}
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        conf[key] = send key
      end

      conf
    end

    def enroll(identity_context, msp_id)
      crypto_suite = identity_context.crypto_suite
      private_key = crypto_suite.generate_private_key
      certificate_request = crypto_suite.generate_csr private_key,
                                                      [['CN', identity_context.username]]

      response = post 'enroll', certificate_request: certificate_request.to_s

      identity_context.enroll private_key: private_key,
                              certificate: Base64.decode64(response.result['Cert']),
                              msp_id: msp_id

      identity_context
    end

    def register(params = {})
      post 'register', params
    end

    def tcert(params = {})
      post 'tcert', params
    end
  end
end
