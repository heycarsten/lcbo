module LCBO
  class InventoryRequest

    include CrawlKit::Request

    uri_template 'http://lcbo.com/lcbo-ear/lcbo/product/inventory/searchResults.do?language=EN&itemNumber={product_no}'

  end
end
