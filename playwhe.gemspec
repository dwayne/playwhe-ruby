# -*- encoding: utf-8 -*-
require File.expand_path('../lib/playwhe/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Dwayne R. Crooks"]
  gem.email         = ["me@dwaynecrooks.com"]
  gem.description   = %q{A ruby gem for retrieving and storing Play Whe results.

  The gem provides a ruby API and script for retrieving and storing Play Whe
  results from the National Lotteries Control Board (NLCB) website at
  http://www.nlcb.co.tt/.}
  gem.summary       = %q{A ruby gem for retrieving and storing Play Whe results.}
  gem.homepage      = "http://rubygems.org/gems/playwhe"

  gem.add_dependency('data_mapper', '~> 1.2.0')
  gem.add_dependency('dm-sqlite-adapter', '~> 1.2.0')
  gem.add_dependency('trollop', '~> 1.16.2')

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "playwhe"
  gem.require_paths = ["lib"]
  gem.version       = PlayWhe::VERSION
end
