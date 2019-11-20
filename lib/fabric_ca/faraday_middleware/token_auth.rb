require 'faraday'
require 'base64'

module FabricCA
  module FaradayMiddleware
    class TokenAuth < Faraday::Middleware
      attr_reader :app, :identity

      def call(env)
        if identity
          env[:request_headers] =
            env[:request_headers].merge(
              'Authorization' => generate_auth_header(env)
            )
        end

        app.call env
      end

      def initialize(app, identity)
        @app = app
        @identity = identity
      end

      private

      def generate_auth_header(env)
        body = Base64.strict_encode64(env.body.to_s)
        body_and_cert = body + '.' + identity.certificate

        identity.certificate + '.' +
          Base64.strict_encode64(identity.sign(body_and_cert))
      end
    end
  end
end
