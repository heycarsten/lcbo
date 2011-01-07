class InventoriesCrawler

  include LCBO::CrawlKit::Crawler

  def enum
    ProductListsCrawler.run
  end

  def request(product_id)
    LCBO.inventory(product_id)
  end

  def failure(error, product_id)
    case error
    when LCBO::CrawlKit::NotFoundError
      puts "[missing] Skipped inventory for product ##{product_id}"
    else
      raise error
    end
  end

end
