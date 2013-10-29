module SAQ

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

  def self.product_list(page_num)
    perPage = SAQ::ProductListPage::PER_PAGE
    beginIndex = page_num * perPage
    ProductListPage.process({perPage: perPage, beginIndex: beginIndex, page: page_num}, {}).as_hash
  end

  def self.store_list(page_num=0)
    beginIndex = page_num * SAQ::StoreListPage::PER_PAGE
    StoreListPage.process({beginIndex: beginIndex}, {}).as_hash
  end

  def self.cities_list(page_num=0)
    beginIndex = page_num * SAQ::CitiesListPage::PER_PAGE
    CitiesListPage.process({beginIndex: beginIndex}, {}).as_hash
  end

end
