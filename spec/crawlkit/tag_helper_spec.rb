# coding: utf-8
require 'spec_helper'

describe LCBO::CrawlKit::TagHelper do
  @expectations = {
    ['Hello World']         => %w[hello world],
    ['Éve Picard']          => %w[éve picard eve],
    ['Hello Hello World']   => %w[hello world],
    ['Hello', 'Éve Picard'] => %w[hello éve picard eve],
    ['Hello', 'Éve-Picard'] => %w[hello éve picard évepicard eve evepicard],
    ['Hello', nil, 'World'] => %w[hello world]
  }

  @expectations.each_pair do |input, expectation|
    it "should tagify: #{input} to: #{expectation}" do
      LCBO::CrawlKit::TagHelper[*input].must_equal expectation
    end
  end
end
