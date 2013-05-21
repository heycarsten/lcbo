require 'spec_helper'
require 'yaml'

{ :product_pages      => BCL::ProductPage,
  :store_pages        => BCL::StorePage,
  :inventory_pages    => BCL::InventoryPage,
  :cities_list_pages  => BCL::CitiesListPage,
  :store_list_pages   => BCL::StoreListPage,
  :product_list_pages => BCL::ProductListPage
}.each_pair do |type, page|
  valid_scraper_type = 'bcl.html'

  describe(page) do
    requests = YAML.load_file("spec/pages/#{type}.yml")

    requests.each do |req|
      if req[:file].split("_")[1] == valid_scraper_type
        req[:body] = File.read("spec/pages/#{type}/#{req[:file]}")
        SpecHelper.hydrastub(req[:method], req[:uri], :body => req[:body])

        if req[:sub_uris]
          req[:sub_uris].each do |sub_req|
            sub_req[:body] = File.read("spec/pages/#{type}/#{sub_req[:file]}")
            SpecHelper.hydrastub(:get, sub_req[:uri], :body => sub_req[:body])
          end
        end
      end
    end

    requests.each do |req|
      if req[:file].split("_")[1] == valid_scraper_type
        describe "given a #{req[:desc]}" do
          before do
            @page = page.process(req[:query_params], req[:body_params])
          end

          req[:expectation].each_pair do |key, value|
            it "should have the expected value for :#{key}" do
              @page[key].must_equal value
            end
          end
        end
      end
    end
  end

end
