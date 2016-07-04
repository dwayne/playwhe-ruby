require "http"

module PlayWhe
  module HTTP
    class Response
      attr_reader :response

      def initialize(response)
        @response = response
      end

      def status
        response.status
      end

      def body
        response.to_s
      end

      def ok?
        status == 200
      end
    end

    class Adapter
      attr_reader :http_client

      def initialize(http_client)
        @http_client = http_client
      end

      def post(url, data)
        Response.new http_client.post(url, form: data)
      rescue ::HTTP::Error
        raise PlayWhe::NetworkError
      end
    end
  end
end
