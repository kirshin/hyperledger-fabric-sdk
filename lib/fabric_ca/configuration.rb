module FabricCA
  module Configuration
    VALID_OPTIONS_KEYS = %i[endpoint ca_name identity
                            username password logger
                            connection_opts].freeze

    VALID_OPTIONS_KEYS.each { |attr| attr_accessor attr }

    def self.extended(base)
      base.reset
    end

    def configure
      yield self
    end

    def options
      VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    def reset
      VALID_OPTIONS_KEYS.each { |key| send("#{key}=", nil) }
    end

    def assign(config)
      VALID_OPTIONS_KEYS.each { |key| send("#{key}=", config[key]) if config.key?(key) }
    end
  end
end
