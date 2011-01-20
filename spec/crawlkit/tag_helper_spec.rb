# coding: utf-8
require 'spec_helper'

describe LCBO::CrawlKit::TagHelper do
  @expectations = {
    ['Hello World']         => %w[hello world],
    ['Éve Picard']          => %w[éve picard eve],
    ['Hello Hello World']   => %w[hello world],
    ['É\'ve Picard-Rowe']   => %w[é've éve picard rowe picard-rowe picardrowe e've eve],
    ['Hello', 'Éve Picard'] => %w[hello éve picard eve],
    ['Hello', 'Éve-Picard'] => %w[hello éve picard éve-picard évepicard eve eve-picard evepicard],
    ['Hello', nil, 'World'] => %w[hello world]
  }

  @expectations.each_pair do |input, expectation|
    it "should tagify: #{input} to: #{expectation}" do
      LCBO::CrawlKit::TagHelper[*input].must_equal expectation
    end
  end
end
