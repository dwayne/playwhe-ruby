module PlayWhe
  VERSION = "0.1.0"

  class Error < StandardError; end
  class NetworkError < Error; end
  class BadResponseError < NetworkError
    attr_reader :response

    def initialize(response)
      @response = response
      super("status: #{response.status}, body: #{response.body}")
    end
  end
end

require "playwhe/util"
require "playwhe/http"
require "playwhe/fetcher"
require "playwhe/result"
require "playwhe/parser"
