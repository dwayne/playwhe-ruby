require "test_helper"

describe PlayWhe::HTTP::Adapter do
  let(:url) { "http://example.com" }
  let(:data) { { year: "16" } }

  describe "#post" do
    it "makes a POST request" do
      http_client = Minitest::Mock.new
      http_client.expect(:post, :response, [url, { form: data }])

      http_adapter = PlayWhe::HTTP::Adapter.new(http_client)
      http_adapter.post(url, data)

      expect(http_client.verify).must_equal true
    end

    describe "when successful" do
      it "returns a response" do
        http_client = Object.new
        def http_client.post(*attrs)
          :response
        end

        http_adapter = PlayWhe::HTTP::Adapter.new(http_client)

        expect(http_adapter.post(url, data)).must_be_instance_of \
          PlayWhe::HTTP::Response
      end
    end

    describe "when there is an HTTP::Error" do
      it "raises PlayWhe::NetworkError" do
        http_client = Object.new
        def http_client.post(*attrs)
          raise Class.new(HTTP::Error)
        end

        http_adapter = PlayWhe::HTTP::Adapter.new(http_client)

        expect { http_adapter.post(url, data) }.must_raise \
          PlayWhe::NetworkError
      end
    end
  end
end
