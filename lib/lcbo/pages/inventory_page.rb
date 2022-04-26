module LCBO
  class InventoryPage

    include CrawlKit::Page

    uri 'https://www.lcbo.com/en/storeinventory/?sku={sku}'
    # uri 'https://www.lcbo.com/webapp/wcs/stores/servlet/PhysicalStoreInventoryView?langId=-1&storeId=10203&productId={internal_id}'
    # uri 'https://www.vintages.com/lcbo-ear/vintages/product/inventory/searchResults.do?language=EN&itemNumber={product_id}'
    # uri 'https://www.lcbo.com/webapp/wcs/stores/servlet/ProductStoreInventoryView?partNumber={product_id}'

    # emits :xdoc do
    #   doc
    # end

    emits :product_url do
      doc.css('h1 a[title="Product Name"]')[0].attr(:href)
    end

    emits :product_id do
      # query_params[:internal_id].to_i
      query_params[:sku].to_i
    end

    emits :inventory_count do
      # sums all quantities in inventory json
      inventory_json.inject(0){|s,e| s+= e[6].to_i; s}
    end

    emits :inventories do
      begin
        inventory_json.map do |x|
          {
            quantity: x[6].to_i,
            address: x[2].upcase,
            store_id: x[5],
            phone: x[4]
          }
        end
      rescue
        []
      end
    end


    def inventory_json

      if !doc.css(".inventory_empty_div").empty?
        # No inventory available... not an error
        @inventory_array = []
      else
        # ["City","Intersection","Address Line 1","Address Line 2","Phone Number","Store Number","Available Inventory"]
        @inventory_array ||= JSON.parse doc.to_s.gsub(/[\n\t]/, '').match(/\"storeList\"\:(\[.*\])\, +\"sku\"/)[1]

        @inventory_array ||= []
      end
    end

  end
end
