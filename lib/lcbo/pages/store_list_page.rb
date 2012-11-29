module LCBO
  class StoreListPage

    include CrawlKit::Page

    STORE_COUNT_RANGE = 600..635

    on :after_parse, :verify_number_of_stores

    uri 'http://www.lcbo.com/lcbo-webapp/storequery.do?searchType=proximity&longitude=-79.0&latitude=43.0&numstores=999&language=EN'

    emits :store_ids do
      @store_ids ||= begin
        doc.xpath('//store/locationnumber').map { |node| node.content.to_i }
      end
    end

    def verify_number_of_stores
      return if STORE_COUNT_RANGE.include?(store_ids.length)
      raise CrawlKit::MalformedError,
        "Store count (#{store_ids.length}) not in range: #{STORE_COUNT_RANGE}"
    end

  end
end
