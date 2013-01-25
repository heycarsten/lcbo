# coding: utf-8
require File.expand_path("../lib/lcbo/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'lcbo'
  s.version     = '1.3.4' # LCBO::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Carsten Nielsen', 'Lenard Andal', 'Ahmed El-Daly']
  s.email       = ['aeldaly@developergurus.com']
  s.summary     = %q{A library for parsing HTML pages from http://lcbo.com}
  s.description = %q{Request and parse product, store, inventory, and product search pages directly from the official LCBO website.}

  s.add_dependency 'typhoeus',      '~> 0.3.3'
  s.add_dependency 'nokogiri',      '~> 1.5.0'
  s.add_dependency 'unicode_utils', '~> 1.2.2'
  s.add_dependency 'stringex',      '~> 1.3.0'

  s.files         = `git ls-files`.split(?\n)
  s.test_files    = `git ls-files -- {test,spec}/*`.split(?\n)
  s.require_paths = ['lib']
end
