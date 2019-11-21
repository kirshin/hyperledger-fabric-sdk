require 'faraday'

module FabricCA
  module FaradayMiddleware
    class RaiseHttpException < Faraday::Middleware
      ## Variables
      LOGGER_TAG = 'FABRIC CA'.freeze

      ## Attributes
      attr_reader :app, :logger

      def call(env)
        app.call(env).on_complete do |response|
          case response[:status].to_i
          when 400..504
            message = build_error_message response
            logging message

            raise FabricCA::Error.new message, response
          end
        end
      end

      def initialize(app, logger)
        @app = app
        @logger = logger
      end

      private

      def build_error_message(response)
        [
          response[:method].to_s.upcase,
          response[:url],
          response[:status],
          response[:body]
        ].join(', ')
      end

      def logging(message)
        return unless logger

        logger.tagged(LOGGER_TAG) { |logger| logger.error message }
      end
    end
  end
end
