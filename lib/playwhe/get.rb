require "date"
require "ostruct"

require "http"

module PlayWhe
  class << self
    def get
      @_get ||= Get.new(fetcher: fetcher, parser: Parser)
    end

    private

    def fetcher
      settings = Settings.config

      http = ::HTTP.timeout :global,
        read: settings.http.read_timeout,
        write: settings.http.write_timeout,
        connect: settings.http.connect_timeout

      Fetcher.new(HTTP::Adapter.new(http), settings.url)
    end
  end

  class Get
    attr_reader :fetcher, :parser

    def initialize(fetcher:, parser:)
      @fetcher = fetcher
      @parser = parser
    end

    VALID_ORDERS = %i(asc desc)

    def results_for_year(date, order: :asc, skip_validation: false)
      unless !!skip_validation
        date = clean_and_validate_date(date)
        order = clean_and_validate_order(order)
      end

      sort \
        partition(
          parse(fetcher.get(year: date.year)),
          validation_context(date.year)
        ),
        order
    end

    def results_for_month(date, order: :asc, skip_validation: false)
      unless !!skip_validation
        date = clean_and_validate_date(date)
        order = clean_and_validate_order(order)
      end

      sort \
        partition(
          parse(fetcher.get(year: date.year, month: date.month)),
          validation_context(date.year, date.month)
        ),
        order
    end

    def results_for_day(date, order: :asc, skip_validation: false)
      unless !!skip_validation
        date = clean_and_validate_date(date)
        order = clean_and_validate_order(order)
      end

      sort \
        partition(
          parse(fetcher.get(year: date.year, month: date.month)).select { |r|
            r.date == date
          }
        ),
        order
    end

    def most_recent(limit: nil, order: :desc, skip_validation: false)
      unless !!skip_validation
        limit = clean_and_validate_limit(limit)
        order = clean_and_validate_order(order)
      end

      start_year = Date.today.year
      end_year = BIRTHDAY.year
      delta = -1

      results_for_range(start_year, end_year, delta, limit, order)
    end

    def least_recent(limit: nil, order: :asc, skip_validation: false)
      unless !!skip_validation
        limit = clean_and_validate_limit(limit)
        order = clean_and_validate_order(order)
      end

      start_year = BIRTHDAY.year
      end_year = Date.today.year
      delta = 1

      results_for_range(start_year, end_year, delta, limit, order)
    end

    private

    def results_for_range(start_year, end_year, delta, limit, order)
      if limit.zero?
        sort \
          partition(
            parse(fetcher.get(year: start_year)),
            validation_context(start_year)
          ),
          order
      else
        year = start_year
        all = []

        while all.length < limit
          all.concat(parse(fetcher.get(year: year)))
          break if year == end_year
          year += delta
        end

        all = sort_desc(all) if start_year > end_year
        all = sort_asc(all) if start_year < end_year

        sort \
          partition(all[0, limit]),
          order
      end
    end

    def sort(partitioned_results, order)
      [
        send(:"sort_#{order}", partitioned_results.first),
        partitioned_results.last
      ]
    end

    def sort_asc(results)
      default_date = Date.today
      default_period_index = PERIODS.length
      results.sort_by do |r|
        [
          r.date || default_date,
          PERIODS.index(r.period) || default_period_index
        ]
      end
    end

    def sort_desc(results)
      sort_asc(results).reverse
    end

    def partition(results, context = nil)
      results.partition { |r| r.is_valid?(context) }
    end

    def parse(html_results)
      parser.parse(html_results)
    end

    def validation_context(year, month = nil)
      OpenStruct.new(year: year, month: month)
    end

    def clean_and_validate_date(date)
      if date.nil?
        raise ArgumentError, "date is required"
      else
        unless date.instance_of?(Date)
          begin
            date = Date.parse(date.to_s)
          rescue ArgumentError
            raise ArgumentError, "date must be a date"
          end
        end

        if date < BIRTHDAY || date > Date.today
          raise ArgumentError, "date must be between " \
            "#{format_date(BIRTHDAY)} and " \
            "#{format_date(Date.today)} inclusive"
        end
      end

      date
    end

    def clean_and_validate_order(order)
      order = order.to_s.to_sym

      unless VALID_ORDERS.include?(order)
        raise ArgumentError, "order must be one of #{VALID_ORDERS.join(', ')}"
      end

      order
    end

    def clean_and_validate_limit(limit)
      limit = limit.to_i

      if limit < 0
        raise ArgumentError, "limit must be a non-negative integer"
      end

      limit
    end

    def format_date(date)
      date.strftime("%Y-%m-%d")
    end
  end
end
