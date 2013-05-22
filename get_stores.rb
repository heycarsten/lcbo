# script to create stores.yml file for bc

require 'nokogiri'
require 'open-uri'
require 'json'
require 'yaml'

require 'pp'

all_stores_url = 'http://www.bcliquorstores.com/store/locator/location_data_js'

@doc = Nokogiri::HTML(open(all_stores_url))
@data = JSON.parse(@doc.content)

def regions
  @data.each do |region_id, region_hash|
    yield region_hash
    break
  end
end

def cities
  regions do |region_hash|
    tmp_cities = region_hash['cities']
    region_hash.delete('cities')
    tmp_cities.each do |city_id, city_hash|
      yield city_hash, region_hash
    end
  end
end

def stores
  File.open('cities.yml', 'w') do |city_file|

    cities do |city_hash, region_hash|
      tmp_stores = city_hash['stores']
      city_hash.delete('stores')

      db_city_hash = [{
        :state_id => 2, # 1 for ON, 2 for BC
        :name => city_hash['name']
      }]
      write_hash(city_file, db_city_hash)

      tmp_stores.each do |store_id, store_hash|
        yield store_hash, city_hash, region_hash
      end
    end

  end
end


def write_hash(file, hash)
  file.write hash.to_yaml.gsub("!ruby/symbol ", ":").sub("---","")
end

File.open('stores.yml', 'w') do |store_file|
  stores do |store_h, city_h, region_h|

    store_hash = [{
      :name => store_h['name'],
      :city_id => city_h['name'],
      # store number is used for urls, store_id is used for api
      # :api_id => store_h['store_number'] + "-" + store_h['store_id'],
      :api_id => store_h['store_id'].to_i,
      :address => store_h['street_1'],
      :zip_code => store_h['postal_code'],
      :phone_number => nil,
      :is_open => nil,
      :hours => nil,
      :lat => store_h['latitude'].to_f,
      :lng => store_h['longitude'].to_f
    }]

    write_hash(store_file, store_hash)
    
  end
end





# BCL.store(2)