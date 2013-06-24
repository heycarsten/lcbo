require 'json'
require 'open-uri'

module SAQ
  class InventoryPage

    include CrawlKit::Page

    uri 'http://www.saq.com/webapp/wcs/stores/servlet/RechercheSuccursale?inventaire=true&storeId=20002&productId={product_id}&succInventaire=1&regionSelected=0&regionId=0&catalogId=50000&langId=-2&partNumber={product_id}'

    emits :product_id do
      query_params[:product_id].to_i
    end

    emits :inventory_count do
      doc.css('.qte-dispo-succ-fiche').inject(0){|s,i| s += i.content.strip.split("\n")[1].strip.to_i}
    end

    emits :inventories do
      results = []
      doc.css('.Succ_Fiche').each do |store|
        store_id = store.css('.succ-titre.filet-bottom3 a')[0].attr('href').match(/selectedStore=(\d+)&/)[1].to_i
        stock = store.css('.qte-dispo-succ-fiche span')[0].content.to_i
        results << {store_id: store_id, quantity: stock}
      end
      results
    end

  end
end
