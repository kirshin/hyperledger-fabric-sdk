module Fabric
  module Configuration
    DEFAULT_TIMEOUT = 30

    VALID_OPTIONS_KEYS = %i[
      crypto_suite
      orderers
      peers
      event_hubs
      identity
      timeout
      logger
      logger_filters
    ].freeze

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

      self.timeout = DEFAULT_TIMEOUT
    end

    def assign(config)
      VALID_OPTIONS_KEYS.each { |key| send("#{key}=", config[key]) if config.key?(key) }
    end
  end
end
