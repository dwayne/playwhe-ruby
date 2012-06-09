# Play Whe

A ruby gem for retrieving and storing Play Whe results.

The gem provides a ruby API and script for retrieving and storing Play Whe
results from the National Lotteries Control Board (NLCB) website at
http://www.nlcb.co.tt/.

## Installation

Add this line to your application's Gemfile:

    gem 'playwhe'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install playwhe

## Usage

After installation you will have access to both the library and an executable.

To use the library, simply require **playwhe** and you would be able to retrieve
Play Whe results in your code. If you need a way to persist those results, then
you can also require **playwhe/storage**.

The executable is called **playwhe** and it allows you to

1. Create and initialize a database for storing Play Whe results.

        $ playwhe --create # or playwhe -c

2. Update a database with the latest Play Whe results.

        $ playwhe --update # or playwhe -u

   Note that you can create and update one after the other with the following
   command.

        $ playwhe -cu

3. Fetch individual results by month

        $ echo Fetch results for April, 2012
        $ playwhe --fetch 2012-04 # or playwhe -f 2012-04

   or by day.

        $ echo Fetch results for 2nd April, 2012
        $ playwhe --fetch 2012-04-02 # or playwhe -f 2012-04-02

   Note that the fetch is done using a local database of results. So, you must
   have created and updated your own local database before running this command.

## Dev Notes

How to access the library?

    $ irb -Ilib --simple-prompt
    >> require 'playwhe'
    >> require 'playwhe/storage'

How to update **data/playwhe.db**?

    >> PlayWhe::Storage.update './data'

How to update **data/playwhe.db** using **bin/playwhe**?

    $ ruby -Ilib ./bin/playwhe -l debug -u ./data

How to access the data in **data/playwhe.db**?

    >> PlayWhe::Storage.connect './data/playwhe.db'
    >> PlayWhe::Storage::Result.first # for e.g. retrieve the first result

How to access the data in **data/playwhe.db** using **bin/playwhe**?

    $ ruby -Ilib ./bin/playwhe -f 1994-07-04 ./data

## Help

For help using the executable, try

    $ playwhe --help # or playwhe -h

You can also get help, report bugs, make suggestions or ask questions by
contacting Dwayne R. Crooks via email at me@dwaynecrooks.com.
