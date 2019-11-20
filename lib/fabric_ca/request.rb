module FabricCA
  module Request
    def get(path, params = {}, options = {})
      request :get, path, params, options
    end

    def post(path, params = {}, options = {})
      request :post, path, params, options
    end

    def put(path, params = {}, options = {})
      request :put, path, params, options
    end

    def delete(path, params = {}, options = {})
      request :delete, path, params, options
    end

    private

    def request(method, path, params, options)
      response = send_request method, path, params, options

      Response.create response.body
    end

    def send_request(method, path, params, options)
      connection(options).send(method) do |request|
        case method
        when :get, :delete
          request.url(URI.encode(path), params)
        when :post, :put
          request.path = URI.encode path
          request.body = params unless params.empty?
        end
      end
    end
  end
end
