require 'nokogiri'
require 'typhoeus'
require 'unicode_utils'
require 'stringex'
require 'timeout'
require 'uri'

# module LCBO
  module CrawlKit
    USER_AGENT ||= begin
      LCBO.config[:user_agent] ||
      ENV['LCBO_USER_AGENT'] ||
      Typhoeus::USER_AGENT
    end

    class MalformedError < StandardError; end
    class NotFoundError < StandardError; end
    class RedirectedError < StandardError; end
    class RequestFailedError < StandardError; end
    class TimeoutError < StandardError; end
  end
# end

require 'crawlkit/caption_helper'
require 'crawlkit/eventable'
require 'crawlkit/fastdate_helper'
require 'crawlkit/page'
require 'crawlkit/phone_helper'
require 'crawlkit/request'
require 'crawlkit/response'
require 'crawlkit/tag_helper'
require 'crawlkit/request_prototype'
require 'crawlkit/crawler'
require 'crawlkit/titlecase_helper'
require 'crawlkit/volume_helper'
