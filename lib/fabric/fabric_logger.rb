module Fabric
  class FabricLogger
    LOGGER_TAG = 'HYPERLEDGER FABRIC'.colorize(:green).freeze
    FILTERED_MASK = '[FILTERED]'.freeze

    attr_reader :logger, :filters

    def initialize(logger, filters = [])
      @logger = logger
      @filters = [filters].compact
    end

    def error(*args)
      return unless logger

      logger.error filter_message(args.join('|'))
    end

    def info(*args)
      return unless logger

      logger.info filter_message(args.join('|'))
    end

    def debug(*args)
      return unless logger

      logger.debug filter_message(args.join('|'))
    end

    private

    def filter_message(message)
      filters.inject(message) { |msg, filter| msg.gsub(filter, FILTERED_MASK) }
    end
  end
end
