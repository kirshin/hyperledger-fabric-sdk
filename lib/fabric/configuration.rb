module Fabric
  module Configuration
    VALID_OPTIONS_KEYS = [:identity_context, :orderers, :peers]

    attr_accessor *VALID_OPTIONS_KEYS

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
      VALID_OPTIONS_KEYS.each {|key| send("#{key}=", nil)}
    end
  end
end
