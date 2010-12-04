require 'spec_helper'
require 'yaml'

{ :product_pages      => LCBO::ProductPage,
  :store_pages        => LCBO::StorePage,
  :inventory_pages    => LCBO::InventoryPage,
  :product_list_pages => LCBO::ProductListPage,
  :store_list_pages   => LCBO::StoreListPage
}.each_pair do |type, page|

  describe(page) do
    requests = YAML.load_file("spec/pages/#{type}.yml")

    requests.each do |req|
      body = File.read("spec/pages/#{type}/#{req[:file]}")
      req[:body] = body
      SpecHelper.hydrastub(req[:method], req[:uri], :body => req[:body])
    end

    requests.each do |req|
      describe "given a #{req[:desc]}" do
        before do
          @page = page.process(req[:query_params], req[:body_params])
        end

        req[:expectation].each_pair do |key, value|
          it "should have the expected value for :#{key}" do
            if (value.is_a?(String))
              @page[key].must_equal value
            else
              @page[key].must_equal value
            end
          end
        end
      end
    end
  end

end
