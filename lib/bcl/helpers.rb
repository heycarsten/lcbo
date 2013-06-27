module BCL

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

  def self.product(id)
    ProductPage.process(:id => id).as_hash
  end

  def self.store(id)
    StorePage.process(:id => id).as_hash
  end

  def self.inventory(product_id)
    InventoryPage.process(:product_id => product_id).as_hash
  end

  def self.product_list(beginIndex=0)
    ProductListPage.process(:beginIndex => beginIndex*BCL::ProductListPage::PER_PAGE).as_hash
  end

  def self.store_list
    StoreListPage.process({}, {}).as_hash
  end

end
