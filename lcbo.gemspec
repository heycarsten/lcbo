# coding: utf-8
require File.expand_path("../lib/lcbo/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'lcbo'
  s.version     = LCBO::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Carsten Nielsen']
  s.email       = ['heycarsten@gmail.com']
  s.homepage    = 'http://github.com/heycarsten/lcbo'
  s.summary     = %q{A library for parsing HTML pages from http://lcbo.com}
  s.description = %q{Request and parse product, store, inventory, and product search pages directly from the official LCBO website.}

  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project = 'lcbo'

  s.add_dependency 'typhoeus'
  s.add_dependency 'nokogiri'

  s.add_development_dependency 'rspec', '1.3.0'

  s.files         = `git ls-files`.split(?\n)
  s.test_files    = `git ls-files -- {test,spec}/*`.split(?\n)
  s.require_paths = ['lib']

  # If you need an executable, add it here
  # s.executables = ['lcbo']
end
