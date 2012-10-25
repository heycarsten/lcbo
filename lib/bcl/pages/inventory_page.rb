require 'json'

module BCL
  class InventoryPage

    include CrawlKit::Page

    uri 'http://www.bcliquorstores.com/store/locator/location_data_js/{product_id}/product'

    emits :product_id do
      query_params[:product_id].to_i
    end

    emits :inventory_count do
      total = 0
      regions do |region|
        total += region["quantity"].to_i
      end
      total
    end

    emits :inventories do
      # # [updated_on, store_id, quantity]
      # doc.css('table[cellpadding="3"] tr[bgcolor] > td[width="17%"] > a.item-details-col5').zip(
      # doc.css('table[cellpadding="3"] tr[bgcolor] > td > a.item-details-col0'),
      # doc.css('table[cellpadding="3"] tr[bgcolor] > td[width="13%"]')).map do |updated_on, store_id, quantity|
      #   {
      #     :updated_on => CrawlKit::FastDateHelper[updated_on.text.strip],
      #     :store_id => store_id['href'].match(/\?STORE=([0-9]{1,3})\&/)[1].to_i,
      #     :quantity => quantity.content.strip.to_i,
      #   }
      # end
      results = []
      stores do |store_hash|
        results << {
          :store_id => store_hash['store_id'].to_i,
          :quantity => store_hash['quantity'].to_i
        }
      end
      results
    end

    def json
      JSON.parse(doc.content)
    end

    def regions
      json.each do |region_id, region_hash|
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

    def stores
      cities do |city_hash|
        city_hash['stores'].each do |store_id, store_hash|
          yield store_hash
        end
      end
    end

  end
end
