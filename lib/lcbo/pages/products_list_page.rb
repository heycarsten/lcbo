module LCBO
  class ProductsListPage

    PER_PAGE = 100

    include CrawlKit::Page

    http_method :post

    uri 'http://www.lcbo.com/lcbo-ear/lcbo/product/searchResults.do'

    default_body_params \
      :STOCK_TYPE_NAME    => 'All',
      :ITEM_NAME          => '',
      :KEYWORDS           => '',
      :ITEM_NUMBER        => '',
      :productListingType => '',
      :LIQUOR_TYPE_SHORT_ => '*',
      :CATEGORY_NAME      => '*',
      :SUB_CATEGORY_NAME  => '*',
      :PRODUCING_CNAME    => '*',
      :PRODUCING_REGION_N => '*',
      :UNIT_VOLUME        => '*',
      :SELLING_PRICE      => '*',
      :LTO_SALES_CODE     => 'N',
      :VQA_CODE           => 'N',
      :KOSHER_CODE        => 'N',
      :VINTAGES_CODE      => 'N',
      :VALUE_ADD_SALES_CO => 'N',
      :AIR_MILES_SALES_CO => 'N',
      :language           => 'EN',
      :style              => 'LCBO.css',
      :sort               => 'sortedProduct',
      :order              => '1',
      :resultsPerPage     => PER_PAGE.to_s,
      :page               => '1',
      :action             => 'result',
      :sortby             => 'sortedProduct',
      :orderby            => '',
      :numPerPage         => PER_PAGE.to_s

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
        doc.css('td[width="42%"] font.main_font b')[0].
        text.
        gsub(/\s+/, ' ').
        strip.
        to_i
      end
    end

    emits :product_nos do
      product_anchors.reduce([]) do |ary, a|
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
