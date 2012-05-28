require 'date'
require 'net/http'

require 'playwhe/version'

module PlayWhe
  # The day that Play Whe had its first draw; its start date
  BIRTHDAY = Date.parse('4th July 1994')

  # The day that Play Whe changed to having 3 draws per day
  THREE_DRAWS_DAY = Date.parse('21st November 2011')

  HOST = 'nlcb.co.tt'
  QUERY_PATH = 'search/pwq/countdateCash.php'
  QUERY_URL  = URI("http://#{HOST}/#{QUERY_PATH}")

  # the lowest and highest Play Whe marks
  LOWEST_MARK  = 1
  HIGHEST_MARK = 36

  # marks associated with their standard spirit
  SPIRITS = {
    1  => 'centipede',
    2  => 'old lady',
    3  => 'carriage',
    4  => 'dead man',
    5  => 'parson man',
    6  => 'belly',
    7  => 'hog',
    8  => 'tiger',
    9  => 'cattle',
    10 => 'monkey',
    11 => 'corbeau',
    12 => 'king',
    13 => 'crapaud',
    14 => 'money',
    15 => 'sick woman',
    16 => 'jamette',
    17 => 'pigeon',
    18 => 'water boat',
    19 => 'horse',
    20 => 'dog',
    21 => 'mouth',
    22 => 'rat',
    23 => 'house',
    24 => 'queen',
    25 => 'morocoy',
    26 => 'fowl',
    27 => 'little snake',
    28 => 'red fish',
    29 => 'opium man',
    30 => 'house cat',
    31 => 'parson wife',
    32 => 'shrimps',
    33 => 'spider',
    34 => 'blind man',
    35 => 'big snake',
    36 => 'donkey'
  }

  def self.results_for_month(year, month)
    if date_in_range?(year, month)
      params = { 'year'  => (year%100).to_s.rjust(2, '0'),
                 'month' => Date::ABBR_MONTHNAMES[month] }

      begin
        response = Net::HTTP.post_form(QUERY_URL, params)
      rescue
        raise ServiceUnavailable
      end

      case response
      when Net::HTTPOK
        return parse_body(year, params['year'], month, params['month'], response.body)
      else
        raise ServiceUnavailable
      end
    else
      # obviously we won't have any results
      return []
    end
  end

  def self.results_for_year(year, callbacks = {})
    all_results = []

    12.times do |m|
      month = m + 1

      skip = callbacks[:before] ? callbacks[:before].call(month) : false

      unless skip
        begin
          flag = :ok
          results = results_for_month(year, month)
        rescue ServiceUnavailable
          flag = :error
          results = []
        ensure
          begin
            continue = callbacks[:after] ? callbacks[:after].call(month, flag, results) : true
          rescue
            raise
          ensure
            all_results += results if results
          end
        end

        break unless continue
      end
    end

    all_results
  end

  class ServiceUnavailable < Exception
  end

private

  def self.date_in_range?(year, month)
    mday = year == BIRTHDAY.year && month == BIRTHDAY.month ? BIRTHDAY.day : 1
    date = Date.new(year, month, mday)

    date >= BIRTHDAY && date <= Date.today
  end

  def self.parse_body(year, yy, month, abbr_month, body)
    # Here's the current form of the data on the page as of 27/05/2012:
    #
    # <date>: Draw # <draw> : <period>'s draw  was <mark>
    #
    # where
    #
    # <date>  : dd-Mmm-yy
    # <draw>  : a positive integer
    # <period>: Morning | Midday | Evening
    # <mark>  : 1..36
    results = body.scan(/(\d{2})-#{abbr_month}-#{yy}: Draw # (\d+) : (Morning|Midday|Evening)'s draw  was (\d+)/)

    results.collect! do |r|
      { draw: r[1].to_i,
        date: Date.new(year, month, r[0].to_i),
        period: {'Morning' => 1, 'Midday' => 2, 'Evening' => 3}[r[2]],
        mark: r[3].to_i }
    end.sort_by! { |r| r[:draw] }
  end
end
