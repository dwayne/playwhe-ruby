require "date"

module PlayWhe
  class Result
    attr_reader :draw, :date, :mark, :period
    attr_reader :errors

    def initialize(draw:, date:, mark:, period:)
      @draw = draw
      @date = date
      @mark = mark
      @period = period
      clean
    end

    def ==(other)
      return true if other.equal?(self)
      return false unless other.instance_of?(self.class)
      draw == other.draw &&
        date == other.date &&
          mark == other.mark &&
            period == other.period
    end

    def to_s
      "#{draw},#{date ? date.strftime('%Y-%m-%d') : '-'},#{mark},#{period}"
    end

    def is_valid?(context = nil)
      validate(context)
      no_errors?
    end

    private

    attr_reader :context

    def clean
      clean_draw
      clean_date
      clean_mark
      clean_period
    end

    def clean_draw
      @draw = draw.to_i
    end

    def clean_date
      @date = Date.parse(date.to_s) unless date.is_a?(Date)
    rescue ArgumentError
      @date = nil
    end

    def clean_mark
      @mark = mark.to_i
    end

    def clean_period
      @period = period.to_s.upcase
    end

    def validate(context)
      init(context)
      validate_draw
      validate_date
      validate_mark
      validate_period
    end

    def init(context)
      @context = context
      @errors = {}
    end

    def add_error(name, message)
      @errors[name] ||= []
      @errors[name] << message
    end

    def no_errors?
      errors.empty?
    end

    def validate_draw
      add_error(:draw, "must be a positive integer") unless draw >= 1
    end

    def validate_date
      if date.nil?
        add_error(:date, "must be a date")
      else
        if date < BIRTHDAY
          add_error(:date, "must be greater than Play Whe's birthday")
        end

        if context && context.year && date.year != context.year
          add_error(:date, "must be for the correct year (#{context.year})")
        end

        if context && context.month && date.month != context.month
          add_error(:date, "must be for the correct month (#{context.month})")
        end
      end
    end

    def validate_mark
      if mark < LOWEST_MARK || mark > HIGHEST_MARK
        add_error(:mark, "must be between #{LOWEST_MARK} and #{HIGHEST_MARK} inclusive")
      end
    end

    def validate_period
      unless PERIODS.include?(period)
        add_error(:period, "must be one of #{PERIODS.join(', ')}")
      end
    end
  end
end
