module Fabric
  class TransactionInfo
    attr_reader :tx_id, :nonce, :identity

    def initialize(identity)
      @identity = identity
      @nonce = identity.crypto_suite.generate_nonce
      @tx_id = identity.crypto_suite.hexdigest(nonce + identity.serialize)
    end

    def nonce_hex
      identity.crypto_suite.encode_hex nonce
    end

    def signature_header
      ::Common::SignatureHeader.new creator: identity.serialize, nonce: nonce
    end
  end
end
