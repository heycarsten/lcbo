class InventoryParser

  include LCBO::CrawlKit::Parser

  uri_template 'http://lcbo.com/lcbo-ear/lcbo/product/inventory/searchResults.do?language=EN&itemNumber={product_no}'

  def product_no
    params[:product_no].to_i
  end

  def as_array
    return [] if @html.include?('No store in the selected city')
    inventories
  end

  def as_hash
    { :product_no => product_no,
      :inventories => as_array }
  end

  private

  def inventories
    # [updated_on, store_no, quantity]
    inventory_table_rows.inject([]) do |ary, node|
      h = {}
      h[:updated_on] = begin
        FastDateHelper[
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
        text.
        strip.
        to_i
      end
      ary << h
    end
  end

  def inventory_table
    doc.css('table[cellpadding="3"]')
  end

  def inventory_table_rows
    inventory_table.css('tr[bgcolor]')
  end

end
