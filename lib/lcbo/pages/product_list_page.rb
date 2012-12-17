module LCBO
  class ProductListPage

    include CrawlKit::Page

    PER_PAGE = 100

    uri 'http://lcbo.com/lcbo-ear/lcbo/product/searchResults.do?' \
      'STOCK_TYPE_NAME=All&' \
      'ITEM_NAME=&KEYWORDS=&' \
      'ITEM_NUMBER=&' \
      'productListingType=&' \
      'LIQUOR_TYPE_SHORT_=*&' \
      'CATEGORY_NAME=*&' \
      'SUB_CATEGORY_NAME=*&' \
      'PRODUCING_CNAME=*&' \
      'PRODUCING_SUBREGION_N=&' \
      'PRODUCING_REGION_N=*&' \
      'UNIT_VOLUME=*&' \
      'SELLING_PRICE=*&' \
      'LTO_SALES_CODE=&' \
      'VQA_CODE=&KOSHER_CODE=&' \
      'VINTAGES_CODE=&' \
      'VALUE_ADD_SALES_CO=&' \
      'AIR_MILES_SALES_CO=&' \
      'SWEETNESS_DESCRIPTOR=&' \
      'VARIETAL_NAME=&' \
      'WINE_STYLE=&' \
      'language=EN&' \
      'style=+LCBO.css&' \
      'page={page}&' \
      'action=result&' \
      'sort=sortedName&' \
      'order=1&' \
      "resultsPerPage=#{PER_PAGE}"

    emits :page do
      query_params[:page].to_i
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
        doc.css("td[width='58%'] font.main_font b")[0].
        text.
        gsub(/\s+/, ' ').
        strip.
        to_i
      end
    end

    emits :product_ids do
      product_anchors.reduce([]) do |ary, a|
        if (match = a.attribute('href').value.match(/\&itemNumber=([0-9]+)/))
          ary << (match.captures[0].to_i)
        else
          next ary
        end
      end
    end
    alias_method :as_array, :product_ids

    def product_anchors
      doc.css("td[style='padding: 5 5 5 0;'] a.item-details-col2")
    end

  end
end
