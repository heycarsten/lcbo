module LCBO
  class ProductsListRequest

    PER_PAGE = 100

    include CrawlKit::Request

    uri_template 'http://lcbo.com/lcbo-ear/lcbo/product/searchResults.do'

    body_params \
      'STOCK_TYPE_NAME' => 'All',
      'ITEM_NAME' => '',
      'KEYWORDS' => '',
      'ITEM_NUMBER' => '',
      'productListingType' => '',
      'LIQUOR_TYPE_SHORT_' => '*',
      'CATEGORY_NAME' => '*',
      'SUB_CATEGORY_NAME' => '*',
      'PRODUCING_CNAME' => '*',
      'PRODUCING_REGION_N' => '*',
      'UNIT_VOLUME' => '*',
      'SELLING_PRICE' => '*',
      'LTO_SALES_CODE' => 'N',
      'VQA_CODE' => 'N',
      'KOSHER_CODE' => 'N',
      'VINTAGES_CODE' => 'N',
      'VALUE_ADD_SALES_CO' => 'N',
      'AIR_MILES_SALES_CO' => 'N',
      'language' => 'EN',
      'style' => ' LCBO.css',
      'sort' => 'sortedProduct',
      'order' => '1',
      'resultsPerPage' => PER_PAGE.to_s,
      'page' => '1',
      'action' => 'result'

  end
end
