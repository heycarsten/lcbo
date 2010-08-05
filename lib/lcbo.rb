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
    ProductPage.process(:product_no => product_no)
  end

  def self.store(store_no)
    StorePage.process(:store_no => store_no)
  end

  def self.inventory(product_no)
    InventoryPage.process(:product_no => product_no)
  end

  def self.products_list(page = 1)
    ProductsListPage.process({}, { :page => page })
  end

end

require 'lcbo/version'
require 'lcbo/ext'
require 'lcbo/crawlkit'
require 'lcbo/pages'
require 'lcbo/crawlers'
