module LCBO

  DEFAULT_CONFIG = {
    :user_agent  => nil, # Use the default User-Agent by default
    :max_retries => 8,   # Number of times to retry a request that fails
    :timeout     => 2    # Seconds to wait for a request before timing out
  }.freeze

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
