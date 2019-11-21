module FabricCA
  class Client
    include Connection
    include Request

    Configuration::VALID_OPTIONS_KEYS.each { |attr| attr_accessor attr }

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

    def enroll(certificate_request, attrs = nil)
      post 'enroll', certificate_request: certificate_request.to_s,
                     caName: ca_name,
                     attr_reqs: attrs
    end

    def register(params = {})
      post 'register', params
    end

    def list_identities(opts = {})
      get 'identities', opts
    end

    def list_affiliations(opts = {})
      get 'affiliations', opts
    end
  end
end
