require 'spec_helper'
require 'date'

describe LCBO::CrawlKit::FastDateHelper do
  @expectations = {
    ''             => nil,
    ' '            => nil,
    "\n"           => nil,
    'belch-fart-2' => nil,
    'Jan 2, 2001'  => Date.new(2001,  1,  2),
    'Dec 22, 2010' => Date.new(2010, 12, 22),
    'Feb 26, 1960' => Date.new(1960,  2, 26) }

  @expectations.each_pair do |input, expectation|
    it "should translate: #{input.inspect} to: #{expectation.inspect}" do
      LCBO::CrawlKit::FastDateHelper[input].must_equal expectation
    end
  end
end
