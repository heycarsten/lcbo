# coding: utf-8

require 'spec_helper'

describe LCBO::CrawlKit::TagHelper do
  @expectations = {
    'Hello World'       => 'hello world',
    'Éve Picard'        => 'éve eve picard',
    'Hello Hello World' => 'hello world'
  }

  @expectations.each_pair do |input, expectation|
    it "should tagify: #{input.inspect} to: #{expectation.inspect}" do
      LCBO::CrawlKit::TagHelper[input].must_equal expectation
    end
  end
end
