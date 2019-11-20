module FabricCA
  class Error < StandardError
    attr_reader :response, :full_message

    def initialize(message, response)
      super message

      @response = Hashie::Mash.new JSON.parse(response.body)
      @full_message = @response.errors.map(&:message).join(', ')
    end
  end
end
