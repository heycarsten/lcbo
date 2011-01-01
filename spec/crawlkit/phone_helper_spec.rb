require 'spec_helper'

describe LCBO::CrawlKit::PhoneHelper do
  @expectations = {
    '(416) 5558255' => '(416) 555-8255',
    '416 555 8255'  => '(416) 555-8255',
    nil             => nil,
    '     '         => nil,
    ''              => nil
  }

  @expectations.each_pair do |input, expectation|
    it "should format: #{input} to: #{expectation}" do
      LCBO::CrawlKit::PhoneHelper[input].must_equal expectation
    end
  end
end
