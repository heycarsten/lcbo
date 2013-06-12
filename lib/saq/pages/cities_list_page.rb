module SAQ
  class CitiesListPage

    include CrawlKit::Page

    uri 'http://www.saq.com/webapp/wcs/stores/servlet/SAQStoreLocator?storeId=20002&catalogId=50000&regionSelected=01&regionId=01'

    SCRAPE_DATA_FROM_JS_REGEX = {
      # store_id: /storeAll\['code_succursale'\] = '(\d+)';/,
      # latitude: /storeAll\['latitude'\] = (-?\d+(\.\d+)?);/,
      # longitude: /storeAll\['longitude'\] = (-?\d+(\.\d+)?);/,
      # address: /storeAll\['adresse'\] = ([^;]+);/,
      city: /storeAll\['ville'\] = '([^;]+)';/,
      # postal_code: /storeAll\['code_postal'\] = '([^;]+)';/,
      # phone: /storeAll\['telephone'\] = '([^;]+)';/,
    }

    def scrape_store_hash(content)
      SCRAPE_DATA_FROM_JS_REGEX.inject({}) do |result,regex_hash|
        result[regex_hash[0]] = content.match(regex_hash[1]).to_a[1]
        result
      end
    end

    emits :city_list do
      doc.css('script').inject([]) do |result,script|
        x = scrape_store_hash(script.content)[:city]
        result << x if x && !result.include?(x)
        result
      end.sort
    end

  end
end
