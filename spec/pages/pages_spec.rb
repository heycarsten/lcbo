require 'spec_helper'
require 'yaml'

describe LCBO::ProductPage do

  { :product_pages => LCBO::ProductPage,
    :store_pages   => LCBO::StorePage
  }.each_pair do |type, page|
    expectations = YAML.load_file("spec/pages/#{type}.yml")

    expectations.each do |expectation|
      body = File.read("spec/pages/#{type}/#{expectation[:file]}")
      expectation[:body] = body
      SpecHelper.hydrastub(:get, expectation[:uri], :body => expectation[:body])
    end

    expectations.each do |expectation|
      context "given a #{expectation[:desc]}" do
        before :all do
          @page = page.request(expectation[:query_params])
        end

        expectation[:expectation].each_pair do |key, value|
          it "should have the expected value for :#{key}" do
            @page[key].should == value
          end
        end
      end
    end
  end

end
