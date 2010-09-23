module LCBO

  DEFAULT_CONFIG = {
    :user_agent => nil,
  }

  def self.config
    reset_config! unless @config
    @config
  end

  def self.reset_config!
    @config = DEFAULT_CONFIG.dup
  end

end

require 'lcbo/version'
require 'lcbo/ext'
require 'lcbo/helpers'
require 'lcbo/crawlkit'
require 'lcbo/pages'
require 'lcbo/crawlers'
