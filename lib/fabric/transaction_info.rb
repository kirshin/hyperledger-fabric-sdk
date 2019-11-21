module Fabric
  class TransactionInfo
    attr_reader :tx_id, :nonce, :crypto_suite, :identity

    def initialize(crypto_suite, identity)
      @identity = identity
      @nonce = crypto_suite.generate_nonce
      @tx_id = crypto_suite.hexdigest(nonce + identity.serialize)
      @crypto_suite = crypto_suite
    end

    def nonce_hex
      crypto_suite.encode_hex nonce
    end

    def signature_header
      ::Common::SignatureHeader.new creator: identity.serialize, nonce: nonce
    end
  end
end
