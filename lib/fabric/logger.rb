module Fabric
  class Logger
    LOGGER_TAG = 'HYPERLEDGER FABRIC'.colorize(:green).freeze
    FILTERED_MASK = '[FILTERED]'.freeze

    attr_reader :logger, :filters

    def initialize(logger, filters = [])
      @logger = logger
      @filters = [filters]
    end

    def error(*args)
      return unless logger

      logger.tagged(LOGGER_TAG) { |logger| logger.error filter_message(args.join('|')) }
    end

    def info(*args)
      return unless logger

      logger.tagged(LOGGER_TAG) { |logger| logger.info filter_message(args.join('|')) }
    end

    def debug(*args)
      return unless logger

      logger.tagged(LOGGER_TAG) { |logger| logger.debug filter_message(args.join('|')) }
    end

    private

    def filter_message(message)
      filters.inject(message) { |msg, filter| msg.gsub(filter, FILTERED_MASK) }
    end
  end
end
