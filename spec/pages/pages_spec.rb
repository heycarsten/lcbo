require 'spec_helper'
require 'yaml'
require 'pp'

describe LCBO::ProductPage do

  @products = YAML.load_file('spec/pages/product_pages.yml')
  @products.each do |product|
    body = File.read("spec/pages/product_pages/#{product[:file]}")
    product[:body] = body
  end

  pp @products

  @products.each do |product|
    context "given a #{product[:desc]}" do
      before :all do
        SpecHelper.hydrastub(:get, product[:uri], :body => product[:body])
        @page = LCBO::ProductPage.request(product[:query_params])
      end

      it 'should meet expectations' do
        @page.name.should == product[:expectation][:name]
      end
    end
  end

end
