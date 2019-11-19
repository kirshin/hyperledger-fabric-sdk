module FabricCA
  module Tools
    HEADER_IDENTIFIER = [1, 2, 3, 4, 5, 6, 9].freeze

    def self.extract_attributes(pem)
      extensions = extract_extensions pem

      attributes = {}
      extensions[HEADER_IDENTIFIER.join('.')].to_s.split('#').each do |key|
        id, num = key.split('->')

        attributes[id] = extensions[build_attribute_id(HEADER_IDENTIFIER, num.to_i).join('.')]
      end

      attributes
    end

    def self.extract_extensions(pem)
      certificate = OpenSSL::X509::Certificate.new pem
      extensions = {}
      certificate.extensions.each { |ext| extensions[ext.oid] = ext.value }

      extensions
    end

    private

      def self.build_attribute_id(header_identifier, step)
        numbers = header_identifier.dup
        numbers[-1] += step

        numbers
      end
  end
end
