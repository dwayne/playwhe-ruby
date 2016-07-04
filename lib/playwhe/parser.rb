module PlayWhe
  module Parser
    PATTERN = /Draw #: <\/strong>(?<draw>\d+).*?Date: <\/strong>(?<day>\d{1,2})-(?<month>[A-Z]{3})-(?<year>\d{2}).*?Mark Drawn: <\/strong>(?<mark>\d+).*?Drawn at: <\/strong>(?<period>[A-Z]{2})/i

    def self.parse(html_results)
      html_results.to_enum(:scan, PATTERN).map do
        m = $~
        date = "#{m[:day]}-#{m[:month]}-#{m[:year]}"

        Result.new \
          draw: m[:draw], date: date, mark: m[:mark], period: m[:period]
      end
    end
  end
end
