module LCBO
  class InventoryPage

    include CrawlKit::Page

    uri 'https://www.lcbo.com/webapp/wcs/stores/servlet/PhysicalStoreInventoryView?langId=-1&storeId=10203&productId={internal_id}'
    # uri 'https://www.vintages.com/lcbo-ear/vintages/product/inventory/searchResults.do?language=EN&itemNumber={product_id}'
    # uri 'https://www.lcbo.com/webapp/wcs/stores/servlet/ProductStoreInventoryView?partNumber={product_id}'

    # emits :xdoc do
    #   doc
    # end

    emits :product_id do
      # query_params[:internal_id].to_i
      query_params[:sku].to_i
    end

    emits :inventory_count do
      inventory_json.inject(0){|s,e| s+= e[1].to_i; s}
    end

    emits :inventories do
      begin
        inventory_json.map do |a1, q1|
          {
            quantity: q1.to_i,
            address: a1
          }
        end
      rescue
        []
      end
    end


    def inventory_json
      @inventory_js_string ||= doc.to_s.gsub(/[\n\t]/, '').match(/var\ storesArray\ =\ \[(.*)\]\;var/)[1]
      @inventory_array ||= @inventory_js_string.to_s.split("},{").map{|e| e.match(/address1\:(.*)\,address2.*Math\.floor\((.*)\)/)[1..2].map{|f| CGI.unescapeHTML(f).strip[1..-2].squeeze(" ")}}

      @inventory_array ||= []
    end

  end
end
