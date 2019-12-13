module Fabric
  class ClientStub
    attr_reader :host, :creds, :options, :logger

    VALID_OPTIONS_KEYS = %i[channel_override timeout propagate_mask channel_args interceptors]

    def initialize(host, creds, options = {})
      @host = host
      @logger = options[:logger]

      @creds = GRPC::Core::ChannelCredentials.new(creds) if creds.is_a?(String)
      @creds ||= :this_channel_is_insecure

      @options = options.slice(*VALID_OPTIONS_KEYS)
    end

    private

    def logging(section, message)
      logger.debug section.to_s.upcase,
                   host,
                   message.to_s
    end
  end
end
