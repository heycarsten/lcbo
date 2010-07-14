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

  def self.product(product_no)
    ProductRequest.parse(:product_no => product_no).as_hash
  end

  def self.store(store_no)
    StoreRequest.parse(:store_no => store_no).as_hash
  end

  def self.inventory(product_no)
    InventoryRequest.parse(:product_no => product_no).as_hash
  end

  def self.products_list(page = 1, per_page = nil)
    ProductsListRequest.parse(:page => page).as_hash
  end

end

require 'lcbo/version'
require 'lcbo/crawlkit'
require 'lcbo/crawlers'
require 'lcbo/parsers'
require 'lcbo/requests'
