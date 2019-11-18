require 'faraday'
require 'base64'

module FabricCA
  module FaradayMiddleware
    class TokenAuth < Faraday::Middleware
      attr_reader :app, :identity_context

      def call(env)
        if identity_context&.enrolled?
          env[:request_headers] =
            env[:request_headers].merge(
              'Authorization' => generate_auth_header(env)
            )
        end

        app.call env
      end

      def initialize(app, identity_context)
        @app = app
        @identity_context = identity_context
      end

      private

        def generate_auth_header(env)
          body = Base64.strict_encode64(env.body.to_s)
          identity = identity_context.identity
          cert = Base64.strict_encode64 identity.certificate
          body_and_cert = body + '.' + cert
          sign = Base64.strict_encode64 identity.sign(body_and_cert)

          cert + '.' + sign
        end
    end
  end
end
