module FabricCA
  class Error < StandardError
    attr_reader :response

    def initialize(message, response)
      super message

      @response = response
    end
  end
end
