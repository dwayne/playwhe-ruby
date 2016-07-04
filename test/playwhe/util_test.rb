require "test_helper"

describe PlayWhe::Util do
  subject { PlayWhe::Util }

  describe "::normalize_year" do
    it "returns the last 2 digits of the year" do
      inputs = [1994, 94, 2016, 16]
      outputs = %w(94 94 16 16)

      inputs.zip(outputs).each do |input, output|
        expect(subject.normalize_year(input)).must_equal output
        expect(subject.normalize_year(input.to_s)).must_equal output
      end
    end
  end

  describe "::normalize_month" do
    describe "when given a number in the range 1 to 12" do
      it "returns the abbreviated month name" do
        inputs = 1..12
        outputs = %w(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)

        inputs.zip(outputs).each do |input, output|
          expect(subject.normalize_month(input)).must_equal output
          expect(subject.normalize_month(input.to_s)).must_equal output
        end
      end
    end

    describe "when given nil" do
      it "returns nil" do
        expect(subject.normalize_month(nil)).must_be_nil
      end
    end
  end
end
