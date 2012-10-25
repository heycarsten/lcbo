module BCL
  class StoreListPage

    include CrawlKit::Page

    STORE_COUNT_RANGE = 595..630

    on :after_parse, :verify_number_of_stores

    http_method :post
    uri 'http://www.lcbo.com/lcbo-ear/lcbo/store/searchResults.do'

    default_body_params \
      :language               => 'EN',
      :searchType             => 'proximity',
      :numstores              => '999',
      :streetNumber           => '',
      :streetName             => '',
      :streetType             => '',
      :streetDirection        => '',
      :municipality_proximity => '',
      :postalCode             => 'M5V1K1',
      :'Find Stores.x'        => '68',
      :'Find Stores.y'        => '9',
      :municipality_citywide  => ''

    emits :store_ids do
      @store_ids ||= begin
        anchors.reduce([]) { |ary, a|
          if (match = a.attribute('href').value.match(/\&STORE=([0-9]+)/))
            ary << match.captures[0].to_i
          else
            next ary
          end
        }.sort
      end
    end

    def anchors
      doc.css('.store-location-list td[width="14%"] a.item-details-col0')
    end

    def verify_number_of_stores
      return if STORE_COUNT_RANGE.include?(store_ids.length)
      raise CrawlKit::MalformedError,
        "Store count (#{store_ids.length}) not in range: #{STORE_COUNT_RANGE}"
    end

  end
end
