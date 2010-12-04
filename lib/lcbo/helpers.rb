module LCBO

  PAGE_TYPES = {
    :product      => 'ProductPage',
    :product_list => 'ProductListPage',
    :store_list   => 'StoreListPage',
    :store        => 'StorePage',
    :inventory    => 'InventoryPage'
  }

  def self.page(type)
    Object.const_get(PAGE_TYPES[type.to_sym])
  end

  def self.parse(page_type, response)
    page[page_type].parse(response)
  end

  def self.product(product_no)
    ProductPage.process(:product_no => product_no).as_hash
  end

  def self.store(store_no)
    StorePage.process(:store_no => store_no).as_hash
  end

  def self.inventory(product_no)
    InventoryPage.process(:product_no => product_no).as_hash
  end

  def self.product_list(page_number)
    ProductListPage.process({}, { :page => page_number }).as_hash
  end

  def self.store_list
    StoreListPage.process({}, {}).as_hash
  end

end
