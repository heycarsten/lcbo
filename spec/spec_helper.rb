require 'bundler'
Bundler.setup

require 'rspec'
require 'lcbo'
require 'support/matchers'

Rspec.configure do |config|
  config.include LCBO::Spec::Matchers
end
