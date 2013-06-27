module SAQ
  class ProductListPage

    include CrawlKit::Page

    uri "http://www.saq.com/webapp/wcs/stores/servlet/SearchDisplay?categoryIdentifier=06&showOnly=product&beginIndex={beginIndex}&pageSize=10&catalogId=50000&sensTri=&storeId=20002"

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
