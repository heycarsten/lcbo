module SAQ

  DEFAULT_CONFIG = {
    :user_agent  => 'Mozilla/5.0 (Windows; U; MSIE 9.0; WIndows NT 9.0; en-US))', # Use the default User-Agent by default
    :max_retries => 8,   # Number of times to retry a request that fails
    :timeout     => 4    # Seconds to wait for a request before timing out
  }.freeze

  def self.config
    reset_config! unless @config
    @config
  end

  def self.reset_config!
    @config = DEFAULT_CONFIG.dup
  end

end

require 'ext'
require 'saq/helpers'
require 'crawlkit'
require 'saq/pages'
