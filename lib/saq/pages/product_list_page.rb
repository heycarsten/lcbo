module SAQ
  class ProductListPage

    include CrawlKit::Page

    PER_PAGE = 100

    uri "http://www.saq.com/webapp/wcs/stores/servlet/SearchDisplay?categoryIdentifier=06&showOnly=product&beginIndex={beginIndex}&pageSize={perPage}&catalogId=50000&sensTri=&storeId=20002"

    default_query_params \
      beginIndex: '0',
      perPage: PER_PAGE.to_s

    emits :page do
      query_params[:page].to_i
    end

    emits :final_page do
      @final_page ||= begin
        count = total_products / PER_PAGE
        0 == (total_products % PER_PAGE) ? count-1 : count
      end
    end

    emits :next_page do
      @next_page ||= begin
        page < final_page ? page + 1 : nil
      end
    end

    emits :total_products do
      @total_products ||= begin
        doc.css(".rechercheNb")[0].content.match(/- (\d+)/)[1].to_i
      end
    end

    emits :product_ids do
      doc.css('.resultats_product .desc').map do |divs|
        divs.content.match(/[Code SAQ :\s*|SAQ code:\s*](\d+)/).to_a[1].to_s
      end
    end

  end
end
