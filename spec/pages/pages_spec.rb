require 'spec_helper'
require 'yaml'

describe LCBO::ProductPage do

  @products = YAML.load_file('spec/pages/product_pages.yml')
  @products.each do |product|
    body = File.read("spec/pages/product_pages/#{product[:file]}")
    product[:body] = body
    SpecHelper.hydrastub(:get, product[:uri], :body => product[:body])
  end

  @products.each do |product|
    context "given a #{product[:desc]}" do
      before :all do
        @page = LCBO::ProductPage.request(product[:query_params])
      end

      product[:expectation].each_pair do |key, value|
        it "should have the expected value for :#{key}" do
          @page[key].should == value
        end
      end
    end
  end

end
