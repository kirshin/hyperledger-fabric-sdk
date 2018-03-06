module Fabric
  class TransactionID
    attr_reader :nonce, :identity_context, :id

    def initialize(identity_context)
      @identity_context = identity_context
      @nonce = identity_context.crypto_suite.generate_nonce
      @id = identity_context.crypto_suite.hexdigest(nonce + identity_context.identity.serialize)
    end
  end
end
