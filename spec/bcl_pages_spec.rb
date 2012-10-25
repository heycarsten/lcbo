require 'spec_helper'
require 'yaml'

{ #:product_pages      => BCL::ProductPage,
  :store_pages        => BCL::StorePage
  #:inventory_pages    => BCL::InventoryPage,
  #:product_list_pages => BCL::ProductListPage,
  #:store_list_pages   => BCL::StoreListPage
}.each_pair do |type, page|
  valid_scrapper_type = 'bcl'

  describe(page) do
    requests = YAML.load_file("spec/pages/#{type}.yml")

    requests.each do |req|
      if req[:scrapper] == valid_scrapper_type
        body = File.read("spec/pages/#{type}/#{req[:file]}")
        req[:body] = body
        SpecHelper.hydrastub(req[:method], req[:uri], :body => req[:body])
      end
    end

    requests.each do |req|
      if req[:scrapper] == valid_scrapper_type
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
