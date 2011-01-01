require 'spec_helper'

describe LCBO::CrawlKit::CaptionHelper do
  @expectations = {
    "<br \\>\r\n\r\n\r\n\t\t\t<p>Super \r\nCool!</p>\r\n\r\n" => 'Super Cool!',
    nil => nil,
    "<br><br>\r\n\r\n\r\n<p>     </p>\t\t\t\r\n" => nil,
    '           ' => nil,
    '' => nil
  }

  @expectations.each_pair do |input, expectation|
    it "should format: #{input.inspect} to: #{expectation.inspect}" do
      LCBO::CrawlKit::CaptionHelper[input].must_equal expectation
    end
  end
end
