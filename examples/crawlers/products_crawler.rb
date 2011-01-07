class ProductsCrawler

  include LCBO::CrawlKit::Crawler

  def enum
    ProductListsCrawler.run
  end

  def request(id)
    LCBO.product(id)
  end

  def failure(error, id)
    case error
    when LCBO::CrawlKit::NotFoundError
      puts "[missing] Skipped product ##{id}"
    else
      raise error
    end
  end

end
