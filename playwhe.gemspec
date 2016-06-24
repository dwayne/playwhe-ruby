lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "playwhe"

Gem::Specification.new do |s|
  s.author = "Dwayne Crooks"
  s.email  = "dwayne@playwhesmarter.com"

  s.description = <<-DESCRIPTION.strip.gsub(/\s+/, " ")
    A Ruby library for retrieving Play Whe results from the
    National Lotteries Control Board (NLCB) website.
  DESCRIPTION

  s.summary  = "Play Whe results should be easy to get"
  s.homepage = "https://rubygems.org/gems/playwhe"
  s.license  = "MIT"

  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.name          = "playwhe"
  s.require_paths = ["lib"]
  s.version       = PlayWhe::VERSION

  s.required_ruby_version = ">= 2.0"

  s.add_runtime_dependency "http", "~> 2.0.2"

  s.add_development_dependency "bundler", "~> 1.0"
  s.add_development_dependency "pry-byebug"
end
