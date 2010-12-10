class StoresCrawler

  include LCBO::CrawlKit::Crawler

  def enum
    LCBO.store_list[:store_nos]
  end

  def request(store_no)
    LCBO.store(store_no)
  end

  def failure(error, store_no)
    case error
    when LCBO::CrawlKit::NotFoundError
      puts "[missing] Skipped store ##{store_no}"
    else
      raise error
    end
  end

end
