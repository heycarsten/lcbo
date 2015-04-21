require 'json'
require 'open-uri'

module BCL
  class InventoryPage

    include CrawlKit::Page

    # FIXME: Duplicated BELOW!!!
    # uri 'http://m.bcliquorstores.com/m/where_to_buy/{product_id}'
    uri 'http://m.bcliquorstores.com/m/api_stores/{product_id}/9999/'

    emits :product_id do
      query_params[:product_id].to_i
    end

    emits :inventory_count do
      @product_page[:total_units]
    end

    emits :nid do
      @nid
    end

    emits :board do
      "BCL"
    end

    emits :inventories do
      results = []
      # doc.css("#listStores li").each do |store_element|
      #   store_id = store_element.css('a.arrow').attribute('href').value.match(/\/m\/stores\/view\/(\d+)/)[1].to_i
      #   stock = store_element.css('a.arrow div:nth-of-type(1)')[0].content.strip.match(/Quantity: (\d+)/)[1].to_i
      #   results << {store_id: store_id, quantity: stock}
      # end

      json.each do |store_element|
        store_id = store_element['serial']
        stock = store_element['quantity'].to_i
        results << {store_id: store_id, quantity: stock}
      end

      results
    end

    def json
      @data ||= JSON.parse(doc.content)
    end

    # emits :xdoc do
    #   @doc
    # end

    def parse
      return if is_parsed?
      return unless @html
      fire :before_parse
      inv_uri = "http://m.bcliquorstores.com/m/api_stores/#{product_id}/9999/"
      @doc = Nokogiri::HTML(CrawlKit::RequestPrototype.new(inv_uri).request().body)
      fire :after_parse
      self
    end

    def request
      return if @html
      fire :before_request

      @product_page = BCL.product(product_id)
      @nid = @product_page[:nid] rescue product_id
      @query_params[:nid] = @nid

      @response = request_prototype.request(query_params, body_params)
      @html     = @response.body

      fire :after_request
      self
    end

  end
end
