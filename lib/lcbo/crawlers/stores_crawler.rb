class StoresCrawler

  def self.run(&block)
    raise ArgumentError, 'block expected' unless block_given?
    (1..720).each do |store_no|
      begin
        yield StoreRequest.parse(:store_no => store_no).as_hash
      rescue LCBO::CrawlKit::Errors::MissingResourceError, Errno::ETIMEDOUT, Timeout::Error
        # Ignore stores that don't exist and timeouts.
      end
    end
  end

end
