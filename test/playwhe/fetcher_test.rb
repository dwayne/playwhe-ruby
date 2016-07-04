require "test_helper"

describe PlayWhe::Fetcher do
  let(:url) { "http://example.com" }
  let(:year) { 2016 }
  let(:month) { 1 }

  describe "#get" do
    it "makes a POST request" do
      good_response = Object.new
      def good_response.ok?
        true
      end
      def good_response.body
        ""
      end

      http_adapter = Minitest::Mock.new
      http_adapter.expect \
        :post, good_response, [url, { year: "16", month: "Jan" }]

      fetcher = PlayWhe::Fetcher.new(http_adapter, url)
      fetcher.get(year: year, month: month)

      expect(http_adapter.verify).must_equal true
    end

    describe "when the response is good" do
      it "returns the body of the response" do
        http_adapter = Object.new
        def http_adapter.post(*args)
          good_response = Object.new
          def good_response.ok?
            true
          end
          def good_response.body
            "results"
          end
          good_response
        end

        fetcher = PlayWhe::Fetcher.new(http_adapter, url)

        expect(fetcher.get(year: year, month: month)).must_equal "results"
      end
    end

    describe "when the response is bad" do
      it "raises PlayWhe::BadResponseError" do
        http_adapter = Object.new
        def http_adapter.post(*args)
          bad_response = Object.new
          def bad_response.ok?
            false
          end
          def bad_response.status
            400
          end
          def bad_response.body
            ""
          end
          bad_response
        end

        fetcher = PlayWhe::Fetcher.new(http_adapter, url)

        expect { fetcher.get(year: year, month: month) }.must_raise \
          PlayWhe::BadResponseError
      end
    end
  end
end
