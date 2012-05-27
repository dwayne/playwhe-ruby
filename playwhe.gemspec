# -*- encoding: utf-8 -*-
require File.expand_path('../lib/playwhe/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Dwayne R. Crooks"]
  gem.email         = ["me@dwaynecrooks.com"]
  gem.description   = %q{A ruby gem for retrieving Play Whe results.

  The gem provides a ruby API for retrieving Play Whe results from the
  National Lotteries Control Board (NLCB) website at http://www.nlcb.co.tt/.}
  gem.summary       = %q{A ruby gem for retrieving Play Whe results.}
  gem.homepage      = "http://rubygems.org/gems/playwhe"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "playwhe"
  gem.require_paths = ["lib"]
  gem.version       = PlayWhe::VERSION
end
