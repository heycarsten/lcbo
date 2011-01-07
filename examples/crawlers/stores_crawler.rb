class StoresCrawler

  include LCBO::CrawlKit::Crawler

  def enum
    LCBO.store_list[:store_ids]
  end

  def request(id)
    LCBO.store(id)
  end

  def failure(error, id)
    case error
    when LCBO::CrawlKit::NotFoundError
      puts "[missing] Skipped store ##{id}"
    else
      raise error
    end
  end

end
