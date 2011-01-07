class ProductsQueueCrawler

  include LCBO::CrawlKit::Crawler

  def pop
    $redis.rpop('lcbo.products.queue')
  end

  def request(id)
    LCBO.product(id)
  end

  def failure(error, id)
    case error
    when LCBO::CrawlKit::NotFoundError
      puts "[missing] Skipped product ##{id}"
      $redis.rpush('lcbo.products.missing', id)
    else
      raise error
    end
  end

end
