class ProductsQueueCrawler

  include LCBO::CrawlKit::Crawler

  def pop
    $redis.rpop('lcbo.products.queue')
  end

  def request(product_no)
    LCBO.product(product_no)
  end

  def failure(error, product_no)
    case error
    when LCBO::CrawlKit::NotFoundError
      puts "[missing] Skipped product ##{product_no}"
      $redis.rpush('lcbo.products.missing', product_no)
    else
      raise error
    end
  end

end
