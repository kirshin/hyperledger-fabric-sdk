module FabricCA
  module Response
    def self.create(response_hash)
      data = response_hash
      data.extend(self)

      data
    end
  end
end
