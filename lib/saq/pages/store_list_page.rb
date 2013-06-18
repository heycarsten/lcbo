module SAQ
  class StoreListPage

    include CrawlKit::Page

    uri 'http://www.saq.com/webapp/wcs/stores/servlet/SAQStoreLocator?codeStore=33527&storeId=20002'

    emits :store_ids do
      doc.css('script').map do |script|
        # puts script.content[0..30]
        script.content.match(/storeAll\['code_succursale'\] = '(\d+)'/)[1] rescue nil
      end.compact
    end

    emits :store_hash do
      doc.css('script').inject({}) do |result,script|
        x = scrape_store_hash(script.content)
        result[x[:store_id]] = scrape_store_hash(script.content) if x[:store_id]
        result
      end
    end
    # alias_method :as_array, :product_ids

    SCRAPE_DATA_FROM_JS_REGEX = {
      store_id: /storeAll\['code_succursale'\] = '(\d+)';/,
      latitude: /storeAll\['latitude'\] = (-?\d+(\.\d+)?);/,
      longitude: /storeAll\['longitude'\] = (-?\d+(\.\d+)?);/,
      address: /storeAll\['adresse'\] = '([^;]+)';/,
      city: /storeAll\['ville'\] = '([^;]+)';/,
      postal_code: /storeAll\['code_postal'\] = '([^;]+)';/,
      phone: /storeAll\['telephone'\] = '([^;]+)';/,
    }

    def scrape_store_hash(content)
      SCRAPE_DATA_FROM_JS_REGEX.inject({}) do |result,regex_hash|
        result[regex_hash[0]] = content.match(regex_hash[1]).to_a[1]
        result
      end
    end

  end
end
