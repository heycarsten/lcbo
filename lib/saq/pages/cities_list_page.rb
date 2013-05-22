module SAQ
  class CitiesListPage

    include CrawlKit::Page

    uri 'http://www.bcliquorstores.com/store/locator/location_data_js'

    # default_body_params \
    #   :STOCK_TYPE_NAME    => 'All',
    #   :ITEM_NAME          => '',
    #   :KEYWORDS           => '',
    #   :ITEM_NUMBER        => '',
    #   :productListingType => '',
    #   :LIQUOR_TYPE_SHORT_ => '*',
    #   :CATEGORY_NAME      => '*',
    #   :SUB_CATEGORY_NAME  => '*',
    #   :PRODUCING_CNAME    => '*',
    #   :PRODUCING_REGION_N => '*',
    #   :UNIT_VOLUME        => '*',
    #   :SELLING_PRICE      => '*',
    #   :LTO_SALES_CODE     => 'N',
    #   :VQA_CODE           => 'N',
    #   :KOSHER_CODE        => 'N',
    #   :VINTAGES_CODE      => 'N',
    #   :VALUE_ADD_SALES_CO => 'N',
    #   :AIR_MILES_SALES_CO => 'N',
    #   :language           => 'EN',
    #   :style              => 'LCBO.css',
    #   :sort               => 'sortedProduct',
    #   :order              => '1',
    #   :resultsPerPage     => PER_PAGE.to_s,
    #   :page               => '1',
    #   :action             => 'result',
    #   :sortby             => 'sortedProduct',
    #   :orderby            => '',
    #   :numPerPage         => PER_PAGE.to_s

    # emits :page do
    #   body_params[:page].to_i
    # end

    # emits :final_page do
    #   @final_page ||= begin
    #     count = total_products / PER_PAGE
    #     0 == (total_products % PER_PAGE) ? count : count + 1
    #   end
    # end

    # emits :next_page do
    #   @next_page ||= begin
    #     page < final_page ? page + 1 : nil
    #   end
    # end

    # emits :total_products do
    #   @total_products ||= begin
    #     doc.css('td[width="58%"] font.main_font b')[0].
    #     text.
    #     gsub(/\s+/, ' ').
    #     strip.
    #     to_i
    #   end
    # end

    emits :city_ids do
      city_hash.keys.sort
    end

    emits :city_hash do
      result = {}
      cities do |city_hash|
        city_hash.delete('stores')
        result[city_hash['city_id']] = city_hash
      end
      result
    end
    # alias_method :as_array, :product_ids

    def data
      @data ||= JSON.parse(doc.content)
    end

    def regions
      data.each do |region_id, region_hash|
        yield region_hash
      end
    end

    def cities
      regions do |region_hash|
        region_hash['cities'].each do |city_id, city_hash|
          yield city_hash
        end
      end
    end


  end
end
