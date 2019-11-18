require 'openssl'

module CryptoSuite
  class ECDSA_AES
    DEFAULT_KEY_SIZE = 256.freeze
    DEFAULT_NONCE_LENGTH = 24.freeze
    DEFAULT_DIGEST_ALGORITHM = 'SHA256'.freeze
    DEFAULT_AES_KEY_SIZE = 128.freeze

    EC_CURVES = { 256 => 'prime256v1', 384 => 'secp384r1' }.freeze

    attr_reader :key_size, :nonce_length, :digest_algorithm, :digest, :cipher

    def initialize(opts = {})
      @key_size = opts[:key_size] || DEFAULT_KEY_SIZE
      @nonce_length = opts[:nonce_length] || DEFAULT_NONCE_LENGTH
      @digest_algorithm = opts[:digest_algorithm] || DEFAULT_DIGEST_ALGORITHM
      @digest = OpenSSL::Digest.new(digest_algorithm)
      @cipher = OpenSSL::Cipher::AES.new(opts[:aes_key_size] || DEFAULT_AES_KEY_SIZE, :CBC)
    end

    def generate_nonce
      OpenSSL::Random.random_bytes nonce_length
    end

    def hexdigest(message)
      @digest.hexdigest message
    end

    def digest(message)
      @digest.digest message
    end

    def sign(private_key, msg)
      key = OpenSSL::PKey::EC.new private_key
      signature = key.dsa_sign_asn1 msg
      sequence = OpenSSL::ASN1.decode signature
      sequence = prevent_malleability sequence, key.group.order

      sequence.to_der
    end

    def generate_private_key
      key = OpenSSL::PKey::EC.new EC_CURVES[key_size]
      key.generate_key!

      key.to_pem
    end

    def generate_csr(private_key, options = [])
      key = OpenSSL::PKey::EC.new private_key
      req = OpenSSL::X509::Request.new
      req.public_key = key
      req.subject = OpenSSL::X509::Name.new(options)
      req.sign key, @digest

      req
    end

    def encrypt(key, iv, message)
      cipher.encrypt key, iv

      Base64.strict_encode64(cipher.update(message) + cipher.final)
    end

    def decrypt(key, iv, message)
      cipher.decrypt key, iv

      cipher.update(Base64.strict_decode64(message)) + cipher.final
    rescue OpenSSL::Cipher::CipherError
      nil
    end

    private

      def prevent_malleability(sequence, order)
        half_order = order >> 1

        if (half_key = sequence.value[1].value) > half_order
          sequence.value[1].value = order - half_key
        end

        sequence
      end
  end
end
