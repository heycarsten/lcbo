module LCBO
  class ProductRequest

    include CrawlKit::Request

    uri_template 'http://lcbo.com/lcbo-ear/lcbo/product/details.do?language=EN&itemNumber={product_no}'

  end
end
