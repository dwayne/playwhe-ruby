module PlayWhe
  class Fetcher
    include Util

    attr_reader :http_adapter, :url

    def initialize(http_adapter, url)
      @http_adapter = http_adapter
      @url = url
    end

    def get(year:, month: 0)
      y = normalize_year(year)
      m = normalize_month(month)

      response = http_adapter.post(url, year: y, month: m)

      if response.ok?
        response.body
      else
        raise BadResponseError, response
      end
    end
  end
end
