$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)

require 'fileutils'
require 'rubygems'
require 'lcbo'
require 'spec'

# Dir["#{File.expand_path('../support', __FILE__)}/*.rb"].each do |file|
#   require file
# end

$debug    = false
$show_err = true

Spec::Runner.configure do |config|
  def check(*args)
    # suppresses ruby warnings about "useless use of == in void context"
    # e.g. check foo.should == bar
  end

  config.before :all do
  end

  config.before :each do
  end

  config.after :each do
  end
end
