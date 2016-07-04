require "test_helper"

describe PlayWhe::HTTP::Response do
  subject { PlayWhe::HTTP::Response.new(response) }

  let(:response) do
    response = OpenStruct.new(status: 200)
    def response.to_s
      "A body"
    end
    response
  end

  it "returns the response's status" do
    expect(subject.status).must_equal response.status
  end

  it "returns the response's body" do
    expect(subject.body).must_equal response.to_s
  end

  describe "#ok?" do
    describe "when the status is 200" do
      it "returns true" do
        expect(subject.ok?).must_equal true
      end
    end

    describe "when the status is not 200" do
      before do
        response.status = 400
      end

      it "returns false" do
        expect(subject.ok?).must_equal false
      end
    end
  end
end
