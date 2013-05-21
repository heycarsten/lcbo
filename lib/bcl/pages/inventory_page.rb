require 'json'
require 'open-uri'

module BCL
  class InventoryPage

    include CrawlKit::Page

    uri 'http://www.bcliquorstores.com/product/inventory/cities?nid={product_id}'

    emits :product_id do
      query_params[:product_id].to_i
    end

    emits :inventory_count do
      @product_page[:total_units]
    end

    emits :nid do
      @nid
    end

    emits :inventories do
      results = []
      doc.css("a.checkcity").each do |store_id|
        store_uri = "http://www.bcliquorstores.com/product/inventory?cnid=#{@nid}&ctid=#{store_id['tid']}"
        Nokogiri::HTML(CrawlKit::RequestPrototype.new(store_uri).request().body).css("td").to_a.each_slice(2) do |inv|
          store_id = inv[0].css('a')[0]['href'].match(/\d+/)[0].to_i
          stock = inv[1].content.to_i
          results << {store_id: store_id, quantity: stock}
        end
      end
      results
    end

    def parse
      return if is_parsed?
      return unless @html
      fire :before_parse
      @product_page = BCL.product(product_id)
      @nid = @product_page[:nid] rescue product_id
      inv_uri = "http://www.bcliquorstores.com/product/inventory/cities?nid=#{@nid}"
      @doc = Nokogiri::HTML(CrawlKit::RequestPrototype.new(inv_uri).request().body)
      fire :after_parse
      self
    end

    def json
      # JSON.parse(doc.content)
    end

    def regions
      # json.each do |region_id, region_hash|
      #   yield region_hash
      # end
    end

    def cities
      # regions do |region_hash|
      #   region_hash['cities'].each do |city_id, city_hash|
      #     yield city_hash
      #   end
      # end
    end

    def stores
      # cities do |city_hash|
      #   city_hash['stores'].each do |store_id, store_hash|
      #     yield store_hash
      #   end
      # end
    end

  end
end
