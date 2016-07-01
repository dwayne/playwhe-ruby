require "date"

module PlayWhe
  # Play Whe's birthday, July 4th, 1994
  BIRTHDAY = Date.new(1994, 7, 4)

  # The date that Play Whe changed to having 3 draws per day
  THREE_DRAWS_DATE = Date.new(2011, 11, 21) # November 21st, 2011

  # The date that Play Whe changed to having 4 draws per day
  FOUR_DRAWS_DATE = Date.new(2015, 7, 6) # July 6th, 2015

  # The lowest Play Whe mark
  LOWEST_MARK = 1

  # The highest Play Whe mark
  HIGHEST_MARK = 36

  # The spirit name associated with each mark
  SPIRITS = {
     1 => "centipede",
     2 => "old lady",
     3 => "carriage",
     4 => "dead man",
     5 => "parson man",
     6 => "belly",
     7 => "hog",
     8 => "tiger",
     9 => "cattle",
    10 => "monkey",
    11 => "corbeau",
    12 => "king",
    13 => "crapaud",
    14 => "money",
    15 => "sick woman",
    16 => "jamette",
    17 => "pigeon",
    18 => "water boat",
    19 => "horse",
    20 => "dog",
    21 => "mouth",
    22 => "rat",
    23 => "house",
    24 => "queen",
    25 => "morocoy",
    26 => "fowl",
    27 => "little snake",
    28 => "red fish",
    29 => "opium man",
    30 => "house cat",
    31 => "parson wife",
    32 => "shrimps",
    33 => "spider",
    34 => "blind man",
    35 => "big snake",
    36 => "donkey"
  }

  # The short-hand names for the time of day Play Whe results are drawn,
  # ordered by earliest to latest
  PERIODS = %w(EM AM AN PM)

  # The times of day, represented as seconds past midnight, that Play Whe
  # results are drawn
  DRAW_TIMES = {
    'EM' => 10 * 3600,       # 10:00 AM
    'AM' => 13 * 3600,       #  1:00 PM
    'AN' => 16 * 3600,       #  4:00 PM
    'PM' => 18 * 3600 + 1800 #  6:30 PM
  }

  class Error < StandardError; end
  class NetworkError < Error; end
  class BadResponseError < NetworkError
    attr_reader :response

    def initialize(response)
      @response = response
      super("status: #{response.status}, body: #{response.body}")
    end
  end
end

require "playwhe/version"
require "playwhe/settings"
require "playwhe/util"
require "playwhe/http"
require "playwhe/fetcher"
require "playwhe/result"
require "playwhe/parser"
require "playwhe/get"
