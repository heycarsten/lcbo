class ProductsCrawler

  include LCBO::CrawlKit::Crawler

  def enum
    ProductListsCrawler.run
  end

  def request(product_no)
    LCBO.product(product_no)
  end

  def failure(error, product_no)
    case error
    when LCBO::CrawlKit::NotFoundError
      puts "[missing] Skipped product ##{product_no}"
    else
      raise error
    end
  end

end
