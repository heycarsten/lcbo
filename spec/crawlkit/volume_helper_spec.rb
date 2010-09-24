require 'spec_helper'

describe LCBO::CrawlKit::VolumeHelper do
  @expectations = {
    '10x500 mL bottles' => 5000,
    '6x330 mL cans'     => 1980,
    '1500 mL bottle'    => 1500,
    'null'              => 0,
    ''                  => 0,
    '  '                => 0,
    "\n"                => 0,
    'case'              => 0,
    '6 parts'           => 0,
    nil                 => 0 }

  @expectations.each_pair do |input, expectation|
    it "should convert: #{input.inspect} to: #{expectation.inspect}" do
      LCBO::CrawlKit::VolumeHelper[input].must_equal expectation
    end
  end
end
