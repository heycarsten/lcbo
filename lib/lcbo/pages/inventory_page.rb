module LCBO
  class InventoryPage

    include CrawlKit::Page

    uri 'http://lcbo.com/lcbo-ear/lcbo/product/inventory/searchResults.do?' \
        'language=EN&itemNumber={product_no}'

    emits :product_no do
      query_params[:product_no].to_i
    end

    emits :inventories do
      # [updated_on, store_no, quantity]
      inventory_table_rows.reduce({}) do |ary, node|
        h = {}
        h[:updated_on] = begin
          CrawlKit::FastDateHelper[
          node.
          css('td[width="17%"]')[-1].
          text.
          strip]
        end
        h[:store_no] = begin
          node.
          css('td[width="38%"] a.item-details-col2').
          attribute('href').
          value.
          match(/\?STORE=([0-9]{1,3})\&/).
          captures[0].
          to_s.
          to_i
        end
        h[:quantity] = begin
          node.
          css('td[width="13%"]')[0].
          content.
          strip.
          to_i
        end
        ary << h
      end
    end

    private

    def inventory_table
      doc.css('table[cellpadding="3"]')
    end

    def inventory_table_rows
      inventory_table.css('tr[bgcolor]')
    end

  end
end
