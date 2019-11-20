require 'faraday'
require 'base64'

module FabricCA
  module FaradayMiddleware
    class BasicAuth < Faraday::Middleware
      attr_reader :app, :username, :password

      def call(env)
        if username && password
          env[:request_headers] =
            env[:request_headers].merge(
              'Authorization' => "Basic #{generate_auth_header}"
            )
        end

        app.call env
      end

      def initialize(app, username, password)
        @app = app
        @username = username
        @password = password
      end

      private

      def generate_auth_header
        Base64.strict_encode64 "#{username}:#{password}"
      end
    end
  end
end
