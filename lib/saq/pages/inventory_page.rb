require 'json'
require 'open-uri'

module SAQ
  class InventoryPage

    include CrawlKit::Page

    uri 'http://www.saq.com/webapp/wcs/stores/servlet/SAQStoreLocatorSearchResultsView?storeId=20002&catalogId=50000&langId=-1&regionSelected=&productId={product_id}&orderBy=1&pageSize=1000&regionId=&x=58&y=12'

    emits :product_id do
      query_params[:product_id].to_i
    end

    emits :board do
      "SAQ"
    end

    emits :inventory_count do
      doc.css('.affichageListe .fiche .succ-dispo').inject(0){|s,i| s += i.content.strip.split("\n")[1].to_i}
    end

    emits :inventories do
      results = []
      doc.css('.affichageListe .fiche').each do |store|
        store_id = store.css('.titre')[0].content.strip.split("\n")[0].match(/(\d+)$/)[0].to_i
        stock = store.css('.succ-dispo')[0].content.strip.split("\n")[1].to_i
        results << {store_id: store_id, quantity: stock}
      end
      results
    end

  end
end
