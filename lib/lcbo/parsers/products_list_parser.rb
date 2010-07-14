module LCBO
  class ProductsListParser

    include CrawlKit::Parser

    emits \
      :page,
      :total_products,
      :product_nos,
      :next_page,
      :final_page

    def page
      params[:page].to_i
    end

    def final_page
      @final_page ||= begin
        count = total_products / ProductsListRequest::PER_PAGE
        0 == (total_products % ProductsListRequest::PER_PAGE) ? count : count + 1
      end
    end

    def next_page
      @next_page ||= begin
        page < final_page ? page + 1 : nil
      end
    end

    def total_products
      @total_products ||= begin
        doc.css('td[width="42%"] font.main_font b')[0].
        text.
        gsub(/\s+/, ' ').
        strip.
        to_i
      end
    end

    def product_nos
      product_anchors.inject([]) do |ary, a|
        if (match = a.attribute('href').value.match(/\&itemNumber=([0-9]+)/))
          ary << (match.captures[0].to_i)
        else
          next ary
        end
      end
    end
    alias_method :as_array, :product_nos

    protected

    def product_anchors
      doc.css('td[style="padding: 5 5 5 0;"] a.item-details-col2')
    end

  end
end
