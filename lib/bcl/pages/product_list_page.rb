module BCL
  class ProductListPage

    include CrawlKit::Page

    PER_PAGE = 10
    uri "http://www.bcliquorstores.com/product-catalogue?start={beginIndex}"

    emits :page do
      body_params[:page].to_i
    end

    emits :final_page do
      @final_page ||= begin
        count = total_products / PER_PAGE
        0 == (total_products % PER_PAGE) ? count : count + 1
      end
    end

    emits :next_page do
      @next_page ||= begin
        page < final_page ? page + 1 : nil
      end
    end

    emits :total_products do
      @total_products ||= begin
        doc.css(".solrsearch-paginator-static").first.text =~ /Showing from \d+ to \d+ of (\d+)/
        $1.to_i
      end
    end

    def product_ids
      doc.css("#solrsearch-pagination li .productlistimage a").map do |divs|
        divs['href'].split("/")[2]
      end
    end

    def products
      product_ids.each do |api_id|
        yield BCL.product(api_id)
      end
    end

    def dox
      doc
    end

  end
end
