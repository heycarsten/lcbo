module LCBO
  module CrawlKit
    class Error < StandardError; end
    class MalformedDocumentError < Error; end
    class MissingResourceError < Error; end
    class RequestFailedError < Error; end
  end
end

require 'addressable/template'
require 'addressable/uri'
require 'nokogiri'
require 'typhoeus'
require 'uri'
require 'yajl'

require 'lcbo/crawlkit/eventable'
require 'lcbo/crawlkit/parser'
require 'lcbo/crawlkit/request'
require 'lcbo/crawlkit/fastdate_helper'
require 'lcbo/crawlkit/titlecase_helper'
require 'lcbo/crawlkit/volume_helper'
