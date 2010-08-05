require 'spec_helper'

describe LCBO::CrawlKit::Request do

  context 'GetRequest' do
    before :all do
      pro = LCBO::CrawlKit::RequestPrototype.new('http://bros.local/bros/{bro_no}')
      @request = LCBO::CrawlKit::Request.new(pro, :bro_no => 1)
    end

    it 'should perform a get request' do
      @request.config[:method].should == :get
    end

    it 'should build a uri based on the query param input' do
      @request.uri.should == 'http://bros.local/bros/1'
    end

    it 'should perform the request' do
      @request.run.body.should == BRO_HTML
    end
  end

  context 'PostRequest' do
    before :all do
      pro = LCBO::CrawlKit::RequestPrototype.new(
        'http://bros.local/search', :post,
        { :q => '', :type => 'all' })
      @request = LCBO::CrawlKit::Request.new(
        pro, {}, { :q => 'test', :type => 'bro' })
    end

    it 'should build a uri appropriately' do
      @request.uri.should == 'http://bros.local/search'
    end

    it 'should perform the request' do
      @request.run.body.should == BRO_SEARCH_HTML
    end
  end
end
