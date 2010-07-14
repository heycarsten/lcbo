module LCBO
  class ProductsCrawler

    def self.run(product_nos, &block)
      raise ArgumentError, 'block expected' unless block_given?
      product_nos.each do |product_no|
        begin
          yield ProductRequest.parse(:product_no => product_no).as_hash
        rescue CrawlKit::MissingResourceError, Errno::ETIMEDOUT, Timeout::Error
          # Ignore products with no data, and timeouts.
        end
      end
    end

  end
end
