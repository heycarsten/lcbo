require 'nokogiri'
require 'typhoeus'
require 'uri'

module LCBO
  module CrawlKit
    USER_AGENT ||= begin
      LCBO.config[:user_agent] ||
      ENV['LCBO_USER_AGENT'] ||
      Typhoeus::USER_AGENT
    end
  end
end

require 'lcbo/crawlkit/eventable'
require 'lcbo/crawlkit/fastdate_helper'
require 'lcbo/crawlkit/page'
require 'lcbo/crawlkit/request'
require 'lcbo/crawlkit/response'
require 'lcbo/crawlkit/request_prototype'
require 'lcbo/crawlkit/titlecase_helper'
require 'lcbo/crawlkit/volume_helper'
