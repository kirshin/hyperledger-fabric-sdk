require 'msp/identities_pb'

module Fabric
  class Identity
    attr_reader :certificate, :public_key, :private_key, :msp_id, :crypto_suite,
                :key, :iv

    def initialize(args)
      @certificate = args[:certificate]
      @public_key = args[:public_key]
      @private_key = args[:private_key]
      @msp_id = args[:msp_id]
      @crypto_suite = args[:crypto_suite]
      @key = args[:key].to_s
      @iv = args[:iv].to_s
    end

    def serialize
      Msp::SerializedIdentity.new(mspid: msp_id, id_bytes: certificate).to_proto
    end

    def sign(message)
      digest = crypto_suite.digest message

      crypto_suite.sign private_key, digest
    end

    def encrypt(message)
      crypto_suite.encrypt key, iv, message
    end

    def decrypt(message)
      crypto_suite.decrypt  key, iv, message
    end
  end
end
