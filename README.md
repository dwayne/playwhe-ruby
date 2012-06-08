# Play Whe

A ruby gem for retrieving and storing Play Whe results.

The gem provides a ruby API for retrieving and storing Play Whe results from the
National Lotteries Control Board (NLCB) website at http://www.nlcb.co.tt/.

## Installation

Add this line to your application's Gemfile:

    gem 'playwhe'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install playwhe

## Notes

How to access the library during development?

    $ irb -Ilib --simple-prompt
    >> require 'playwhe'
    >> require 'playwhe/storage'

How to update **data/playwhe.db**?

    >> PlayWhe::Storage.update './data'

How to access the data in **data/playwhe.db**?

    >> PlayWhe::Storage.connect './data/playwhe.db'
    >> PlayWhe::Storage::Result.first # for e.g. retrieve the first result

## Help

You can get help, report bugs, make suggestions or ask questions by contacting
Dwayne R. Crooks via email at me@dwaynecrooks.com.
