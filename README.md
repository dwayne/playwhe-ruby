## About

playwhe is a Ruby library for retrieving Play Whe results from the [National Lotteries
Control Board](http://www.nlcb.co.tt/) (NLCB) website.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "playwhe"
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install playwhe
```

Inside of your Ruby program do:

```ruby
require "playwhe"
```

... to pull it in as a dependency.

## Usage

This gem comes with a CLI called `playwhe`. Below are some examples of its usage.

List the 4 most recent results in descending order:

```bash
$ playwhe
# or
$ playwhe --most-recent 4
# or
$ playwhe --most-recent --order desc
15253,2016-07-02,29,PM
15252,2016-07-02,30,AN
15251,2016-07-02,31,AM
15250,2016-07-02,29,EM
```

List the 4 most recent results in ascending order:

```bash
$ playwhe --order asc
15250,2016-07-02,29,EM
15251,2016-07-02,31,AM
15252,2016-07-02,30,AN
15253,2016-07-02,29,PM
```

List the 8 least recent results in ascending order:

```bash
$ playwhe --least-recent 8
1,1994-07-04,15,AM
2,1994-07-04,11,PM
3,1994-07-05,36,AM
4,1994-07-05,31,PM
5,1994-07-06,12,AM
6,1994-07-06,36,PM
7,1994-07-07,6,AM
8,1994-07-07,23,PM
```

List all the results for the year 2015 in ascending order:

```bash
$ playwhe 2015
13562,2015-01-01,29,EM
13563,2015-01-01,29,AM
13564,2015-01-01,1,PM
...
14630,2015-12-31,15,EM
14631,2015-12-31,13,AM
14632,2015-12-31,28,AN
14633,2015-12-31,27,PM
```

List all the results for April 2016 in descending order:

```bash
$ playwhe 2016 4 --order desc
15041,2016-04-30,3,PM
15040,2016-04-30,6,AN
15039,2016-04-30,31,AM
15038,2016-04-30,27,EM
...
14941,2016-04-01,3,PM
14940,2016-04-01,16,AN
14939,2016-04-01,14,AM
14938,2016-04-01,31,EM
```

List all the results for October 10th, 2008 in ascending order:

```bash
$ playwhe 2008 10 10
8775,2008-10-10,31,AM
8776,2008-10-10,12,PM
```

## Copyright

Copyright (c) 2016 Dwayne Crooks. See [LICENSE](/LICENSE) for further details.
