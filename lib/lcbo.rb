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
    ProductPage.request(:product_no => product_no)
  end

  def self.store(store_no)
    StorePage.request(:store_no => store_no)
  end

  def self.inventory(product_no)
    InventoryPage.request(:product_no => product_no)
  end

  def self.products_list(page = 1, per_page = nil)
    ProductsListPage.request({}, { :page => page })
  end

end

require 'lcbo/version'
require 'lcbo/ext'
require 'lcbo/crawlkit'
require 'lcbo/pages'
require 'lcbo/crawlers'
