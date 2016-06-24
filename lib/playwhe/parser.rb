module PlayWhe
  class Parser
    include Util

    def parse(html_results, year)
      y = normalize_year(year)

      pattern = /Draw #: <\/strong>(?<draw>\d+).*?Date: <\/strong>(?<day>\d{1,2})-(?<month>#{months_alternation})-#{y}.*?Mark Drawn: <\/strong>(?<number>\d+).*?Drawn at: <\/strong>(?<period>[A-Z]{2})/i

      html_results.to_enum(:scan, pattern).map do
        m = $~

        draw = m[:draw].to_i
        date = "#{m[:day]}-#{m[:month]}-#{y}"
        number = m[:number].to_i
        period = m[:period].upcase

        Result.new(draw, date, number, period)
      end
    end
  end
end
