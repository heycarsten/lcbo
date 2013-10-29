module SAQ
  class StoreListPage

    include CrawlKit::Page

    PER_PAGE = 10
    uri 'http://www.saq.com/webapp/wcs/stores/servlet/SAQStoreLocatorSearchResultsView?storeId=20002&catalogId=50000&langId=-2&pageSize=10&beginIndex={beginIndex}'

    emits :page do
      body_params[:beginIndex].to_i / PER_PAGE
    end

    emits :final_page do
      @final_page ||= begin
        count = total_stores / PER_PAGE
        0 == (total_stores % PER_PAGE) ? count : count + 1
      end
    end

    emits :next_page do
      @next_page ||= begin
        page < final_page ? page + 1 : nil
      end
    end

    emits :total_stores do
      @total_stores ||= begin
        doc.css("#content.succursale .nb").first.text =~ /- (\d+) r/
        $1.to_i
      end
    end

    emits :store_ids do
      doc.css('.fiche .entete .titre a').map do |script|
        # puts script, script.content.match(/\D* (\d+)/)[1]
        script.content.match(/\D* (\d+)/)[1] rescue nil
      end.compact
    end

    emits :store_hash do
      doc.css('.fiche').inject({}) do |result,element|
        x = scrape_store_hash(element)
        result[x[:store_id]] = scrape_store_hash(element) if x[:store_id]
        result
      end
    end
    # alias_method :as_array, :product_ids

    def scrape_store_hash(element)
      {
        store_id: element.css('.entete .titre a')[0].content.match(/\D* (\d+)/)[1],
        # latitude: ,
        # longitude: ,
        address: element.css('.adresse')[0].content.gsub(/\ +/,' ').strip.split(/\n/)[0].strip,
        city: element.css('.adresse')[0].content.gsub(/\ +/,' ').strip.split(/\n/)[1].split(",")[0].strip,
        postal_code: element.css('.adresse')[0].content.gsub(/\ +/,' ').strip.split(/\n/)[2].strip,
        # phone: ,
      }
    end

  end
end
