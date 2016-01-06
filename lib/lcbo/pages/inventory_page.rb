module LCBO
  class InventoryPage

    include CrawlKit::Page

    uri 'http://www.vintages.com/lcbo-ear/vintages/product/inventory/searchResults.do?language=EN&itemNumber={product_id}'

    emits :product_id do
      query_params[:product_id].to_i
    end

    emits :inventory_count do
      doc.css('table[cellpadding="5"] tr td[width="80"] p.mainFont').map{|e| e.content.to_i}.inject(:+)
    end

    emits :inventories do
      if doc.css('input[name="inventorySize"]').attr('value').value.to_i.zero?
        []
      else
        # [updated_on, store_id, quantity]
        doc.css('table[cellpadding="5"] tr')[1..-1].map do |tr|
          {
            updated_on: Date.parse(tr.css('td')[2].content).to_s,
            store_id: tr.css('td')[1].css('a').attr("href").content.match(/STORE=(\d+)/)[1].to_i,
            quantity: tr.css('td')[3].content.strip.to_i,
          }
        end
      end
    end

  end
end
