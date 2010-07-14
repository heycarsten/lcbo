require 'spec_helper'

describe LCBO::CrawlKit::FastDateHelper do
  EXPECTATIONS = {
    ''             => nil,
    ' '            => nil,
    "\n"           => nil,
    'belch-fart-2' => nil,
    'Jan 2, 2001'  => '2001-01-02',
    'Dec 22, 2010' => '2010-12-22',
    'Feb 26, 1960' => '1960-02-26' }

  EXPECTATIONS.each_pair do |input, expectation|
    it "should translate: #{input.inspect} to: #{expectation.inspect}" do
      LCBO::CrawlKit::FastDateHelper[input].should == expectation
    end
  end
end
