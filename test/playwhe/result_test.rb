require "test_helper"

describe PlayWhe::Result do
  describe "#to_s" do
    it "returns a comma separated string of it's draw, date, mark and period" do
      result = PlayWhe::Result.new \
        draw: 1, date: "01-01-2016", mark: 5, period: "EM"

      expect(result.to_s).must_equal("1,2016-01-01,5,EM")

      result = PlayWhe::Result.new \
        draw: 1, date: nil, mark: 5, period: "AM"

      expect(result.to_s).must_equal("1,-,5,AM")
    end
  end

  describe "#is_valid?" do
    describe "when it is valid" do
      it "returns true" do
        result = PlayWhe::Result.new \
          draw: 1, date: "01-01-2016", mark: 5, period: "EM"
        context = OpenStruct.new(year: 2016, month: 1)

        expect(result.is_valid?(context)).must_equal true
      end
    end

    describe "when it is not valid" do
      describe "when draw is not valid" do
        it "returns false and sets errors[:draw]" do
          result = PlayWhe::Result.new \
            draw: "x", date: "01-01-2016", mark: 5, period: "EM"

          expect(result.is_valid?).must_equal false
          expect(result.errors.length).must_equal 1
          expect(result.errors[:draw].length).must_equal 1
          expect(result.errors[:draw].first).must_equal \
            "must be a positive integer"
        end
      end

      describe "when date is not valid" do
        describe "when it is nil" do
          it "returns false and sets errors[:date]" do
            result = PlayWhe::Result.new \
              draw: 1, date: nil, mark: 5, period: "EM"

            expect(result.is_valid?).must_equal false
            expect(result.errors.length).must_equal 1
            expect(result.errors[:date].length).must_equal 1
            expect(result.errors[:date].first).must_equal "must be a date"
          end
        end

        describe "when it is less than Play Whe's birthday" do
          it "returns false and sets errors[:date]" do
            result = PlayWhe::Result.new \
              draw: 1, date: PlayWhe::BIRTHDAY - 1, mark: 5, period: "EM"

            expect(result.is_valid?).must_equal false
            expect(result.errors.length).must_equal 1
            expect(result.errors[:date].length).must_equal 1
            expect(result.errors[:date].first).must_equal \
              "must be greater than Play Whe's birthday"
          end
        end

        describe "when it is not for the correct year" do
          it "returns false and sets errors[:date]" do
            result = PlayWhe::Result.new \
              draw: 1, date: "01-01-2016", mark: 5, period: "EM"
            context = OpenStruct.new(year: 2015, month: 1)

            expect(result.is_valid?(context)).must_equal false
            expect(result.errors.length).must_equal 1
            expect(result.errors[:date].length).must_equal 1
            expect(result.errors[:date].first).must_equal \
              "must be for the correct year (2015)"
          end
        end

        describe "when it is not for the correct month" do
          it "returns false and sets errors[:date]" do
            result = PlayWhe::Result.new \
              draw: 1, date: "01-01-2016", mark: 5, period: "EM"
            context = OpenStruct.new(year: 2016, month: 2)

            expect(result.is_valid?(context)).must_equal false
            expect(result.errors.length).must_equal 1
            expect(result.errors[:date].length).must_equal 1
            expect(result.errors[:date].first).must_equal \
              "must be for the correct month (2)"
          end
        end
      end

      describe "when mark is not valid" do
        describe "when mark is less than PlayWhe::LOWEST_MARK" do
          it "returns false and sets errors[:mark]" do
            result = PlayWhe::Result.new \
              draw: 1, date: "01-01-2016", mark: PlayWhe::LOWEST_MARK - 1,
              period: "EM"

            expect(result.is_valid?).must_equal false
            expect(result.errors.length).must_equal 1
            expect(result.errors[:mark].length).must_equal 1
            expect(result.errors[:mark].first).must_equal \
              "must be between #{PlayWhe::LOWEST_MARK} and " \
              "#{PlayWhe::HIGHEST_MARK} inclusive"
          end
        end

        describe "when mark is greater than PlayWhe::HIGHEST_MARK" do
          it "returns false and sets errors[:mark]" do
            result = PlayWhe::Result.new \
              draw: 1, date: "01-01-2016", mark: PlayWhe::HIGHEST_MARK + 1,
              period: "EM"

            expect(result.is_valid?).must_equal false
            expect(result.errors.length).must_equal 1
            expect(result.errors[:mark].length).must_equal 1
            expect(result.errors[:mark].first).must_equal \
              "must be between #{PlayWhe::LOWEST_MARK} and " \
              "#{PlayWhe::HIGHEST_MARK} inclusive"
          end
        end
      end

      describe "when period is not valid" do
        it "retuns false and sets errors[:period]" do
          result = PlayWhe::Result.new \
            draw: 1, date: "01-01-2016", mark: 5, period: "X"

          expect(result.is_valid?).must_equal false
          expect(result.errors.length).must_equal 1
          expect(result.errors[:period].length).must_equal 1
          expect(result.errors[:period].first).must_equal \
            "must be one of EM, AM, AN, PM"
        end
      end

      describe "when multiple attributes aren't valid" do
        it "returns false with errors set for all of the invalid ones" do
          result = PlayWhe::Result.new \
            draw: 1, date: PlayWhe::BIRTHDAY - 1, mark: -1, period: "X"
          context = OpenStruct.new(year: 2016, month: 1)

          expect(result.is_valid?(context)).must_equal false
          expect(result.errors.length).must_equal 3
          expect(result.errors[:date].length).must_equal 3
          expect(result.errors[:mark].length).must_equal 1
          expect(result.errors[:mark].length).must_equal 1
        end
      end
    end
  end
end
