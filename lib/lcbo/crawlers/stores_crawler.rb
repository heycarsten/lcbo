module LCBO
  class StoresCrawler

    MAX_STORE_NO = 850
    MAX_RETRIES = 10

    class EpicTimeoutError < StandardError; end

    def self.run(params, tries = 0, &block)
      begin
        payload = LCBO.store(params[:store_no])
        yield payload
        params[:store_no] = params[:store_nos].pop
        run(params, &block)
      rescue Errno::ETIMEDOUT, Timeout::Error
        raise EpicTimeoutError if tries > MAX_RETRIES
        run(params, (tries + 1), &block)
      rescue LCBO::StorePage::MissingResourceError
        params[:store_no] = params[:store_nos].pop
        run(params, &block)
      end
    end

  end
end
