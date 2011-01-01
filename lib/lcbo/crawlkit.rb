require 'nokogiri'
require 'typhoeus'
require 'unicode_utils'
require 'stringex'
require 'uri'

module LCBO
  module CrawlKit
    USER_AGENT ||= begin
      LCBO.config[:user_agent] ||
      ENV['LCBO_USER_AGENT'] ||
      Typhoeus::USER_AGENT
    end

    class MalformedError < StandardError; end
    class NotFoundError < StandardError; end
    class RequestFailedError < StandardError; end
    class TimeoutError < StandardError; end
  end
end

require 'lcbo/crawlkit/eventable'
require 'lcbo/crawlkit/fastdate_helper'
require 'lcbo/crawlkit/page'
require 'lcbo/crawlkit/phone_helper'
require 'lcbo/crawlkit/request'
require 'lcbo/crawlkit/response'
require 'lcbo/crawlkit/tag_helper'
require 'lcbo/crawlkit/request_prototype'
require 'lcbo/crawlkit/crawler'
require 'lcbo/crawlkit/titlecase_helper'
require 'lcbo/crawlkit/volume_helper'
