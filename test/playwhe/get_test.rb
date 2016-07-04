require "test_helper"

class FakeFetcher
  def initialize(start_year, years: 1, days: 1)
    @results = []

    draw = 1
    end_year = start_year + years - 1
    (start_year..end_year).each do |year|
      (1..12).each do |month|
        (1..days).each do |day|
          date = Date.new(year, month, day)

          PlayWhe::PERIODS.each do |period|
            @results << make_result(draw, date, period)
            draw += 1
          end

          # One bad result per day
          @results << make_result(draw, date, "XM")
          draw += 1
        end
      end
    end

    @results.shuffle!
  end

  def get(year:, month: nil)
    results.select do |r|
      if month.nil?
        r[:date].year == year
      else
        r[:date].year == year && r[:date].month == month
      end
    end
    .map { |r| as_html(r) }
    .join
  end

  private

  attr_reader :results

  def as_html(result)
    draw = result[:draw]
    date = result[:date].strftime("%d-%b-%y")
    mark = result[:mark]
    period = result[:period]

    "<strong> Draw #: </strong>#{draw}<br><strong> Date: </strong>#{date}<br><strong> Mark Drawn: </strong>#{mark}<br><strong> Drawn at: </strong>#{period}"
  end

  def make_result(draw, date, period)
    mark = (PlayWhe::LOWEST_MARK..PlayWhe::HIGHEST_MARK).to_a.shuffle.first
    { draw: draw, date: date, mark: mark, period: period }
  end
end

describe PlayWhe::Get do
  let(:parser) { PlayWhe::Parser }

  describe "#results_for_year" do
    it "returns the results for the year of the given date in ascending order" do
      fetcher = FakeFetcher.new(2014, years: 3) # 2014, 2015, 2016
      get = PlayWhe::Get.new(fetcher: fetcher, parser: parser)

      good_results, bad_results = get.results_for_year(Date.new(2015))

      expect(good_results.length).must_equal(12 * 1 * 4)

      expect(good_results.first.date).must_equal(Date.new(2015, 1, 1))
      expect(good_results.first.period).must_equal("EM")

      expect(good_results.last.date).must_equal(Date.new(2015, 12, 1))
      expect(good_results.last.period).must_equal("PM")

      expect(bad_results.length).must_equal(12 * 1)
    end
  end

  describe "#results_for_month" do
    it "returns the results for the year/month of the given date in ascending order" do
      fetcher = FakeFetcher.new(2015, days: 10)
      get = PlayWhe::Get.new(fetcher: fetcher, parser: parser)

      good_results, bad_results = get.results_for_month(Date.new(2015, 4))

      expect(good_results.length).must_equal(10 * 4)

      expect(good_results.first.date).must_equal(Date.new(2015, 4, 1))
      expect(good_results.first.period).must_equal("EM")

      expect(good_results.last.date).must_equal(Date.new(2015, 4, 10))
      expect(good_results.last.period).must_equal("PM")

      expect(bad_results.length).must_equal(10)
    end
  end

  describe "#results_for_day" do
    it "returns the results for the year/month/day of the given date in ascending order" do
      fetcher = FakeFetcher.new(2015, days: 10)
      get = PlayWhe::Get.new(fetcher: fetcher, parser: parser)

      good_results, bad_results = get.results_for_day(Date.new(2015, 10, 10))

      expect(good_results.length).must_equal(4)

      expect(good_results[0].date).must_equal(Date.new(2015, 10, 10))
      expect(good_results[0].period).must_equal("EM")

      expect(good_results[1].date).must_equal(Date.new(2015, 10, 10))
      expect(good_results[1].period).must_equal("AM")

      expect(good_results[2].date).must_equal(Date.new(2015, 10, 10))
      expect(good_results[2].period).must_equal("AN")

      expect(good_results[3].date).must_equal(Date.new(2015, 10, 10))
      expect(good_results[3].period).must_equal("PM")

      expect(bad_results.length).must_equal(1)
    end
  end

  describe "#most_recent" do
    describe "when limit is a positive integer" do
      it "returns limit results in most recent to least recent order" do
        fetcher = FakeFetcher.new(2015)
        get = PlayWhe::Get.new(fetcher: fetcher, parser: parser)

        good_results, bad_results = get.most_recent(limit: 6)

        expect(good_results.length).must_equal(4)

        expect(good_results[0].date).must_equal(Date.new(2015, 12, 1))
        expect(good_results[0].period).must_equal("PM")

        expect(good_results[1].date).must_equal(Date.new(2015, 12, 1))
        expect(good_results[1].period).must_equal("AN")

        expect(good_results[2].date).must_equal(Date.new(2015, 12, 1))
        expect(good_results[2].period).must_equal("AM")

        expect(good_results[3].date).must_equal(Date.new(2015, 12, 1))
        expect(good_results[3].period).must_equal("EM")

        expect(bad_results.length).must_equal(2)

        expect(bad_results[0].date).must_equal(Date.new(2015, 12, 1))
        expect(bad_results[1].date).must_equal(Date.new(2015, 11, 1))
      end
    end
  end

  describe "#least_recent" do
    describe "when limit is a positive integer" do
      it "returns limit results in least recent to most recent order" do
        fetcher = FakeFetcher.new(2015)
        get = PlayWhe::Get.new(fetcher: fetcher, parser: parser)

        good_results, bad_results = get.least_recent(limit: 6)

        expect(good_results.length).must_equal(5)

        expect(good_results[0].date).must_equal(Date.new(2015, 1, 1))
        expect(good_results[0].period).must_equal("EM")

        expect(good_results[1].date).must_equal(Date.new(2015, 1, 1))
        expect(good_results[1].period).must_equal("AM")

        expect(good_results[2].date).must_equal(Date.new(2015, 1, 1))
        expect(good_results[2].period).must_equal("AN")

        expect(good_results[3].date).must_equal(Date.new(2015, 1, 1))
        expect(good_results[3].period).must_equal("PM")

        expect(good_results[4].date).must_equal(Date.new(2015, 2, 1))
        expect(good_results[4].period).must_equal("EM")

        expect(bad_results.length).must_equal(1)

        expect(bad_results[0].date).must_equal(Date.new(2015, 1, 1))
      end
    end
  end
end
