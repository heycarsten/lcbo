module SAQ
  class CitiesListPage

    include CrawlKit::Page

    PER_PAGE = 10
    uri 'http://www.saq.com/webapp/wcs/stores/servlet/SAQStoreLocatorSearchResultsView?storeId=20002&catalogId=50000&langId=-2&pageSize=10&beginIndex={beginIndex}'

    emits :page do
      body_params[:beginIndex].to_i / PER_PAGE
    end

    emits :final_page do
      @final_page ||= begin
        count = total_cities / PER_PAGE
        0 == (total_cities % PER_PAGE) ? count : count + 1
      end
    end

    emits :next_page do
      @next_page ||= begin
        page < final_page ? page + 1 : nil
      end
    end

    emits :total_cities do
      @total_cities ||= begin
        doc.css("#content.succursale .nb").first.text =~ /- (\d+) r/
        $1.to_i
      end
    end

    emits :city_list do
      doc.css('.fiche .contenu .adresse').map do |address|
        address.content.split("\n")[2].strip.split(",").first.strip rescue nil
      end
    end

  end
end
