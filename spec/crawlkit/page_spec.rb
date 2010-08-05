require 'spec_helper'

describe LCBO::CrawlKit::Page do

  it 'should have a collection of emittable fields' do
    SpecHelper::GetPage.fields.should include(:bro_no, :name, :desc)
    SpecHelper::PostPage.fields.should include(:q, :type, :names)
    SpecHelper::EventedPage.fields.should include(:message)
  end

  describe SpecHelper::GetPage do
    it 'should default to a GET request' do
      SpecHelper::GetPage.http_method.should == :get
    end

    context 'when requested' do
      before :all do
        @page = SpecHelper::GetPage.request(:bro_no => 1)
      end

      it 'should not be parsed' do
        @page.is_parsed?.should be_false
      end

      it 'should have a valid response object' do
        @page.response.should be_a(LCBO::CrawlKit::Response)
      end

      context 'the response' do
        before :all do
          @page.process
        end

        it 'should be directly parsable' do
          page = SpecHelper::GetPage.parse(@page.response)
          page.as_hash.values.should include(*@page.as_hash.values)
        end

        it 'should be parsable from a hash representation' do
          page = SpecHelper::GetPage.parse(@page.response.as_hash)
          page.as_hash.values.should include(*@page.as_hash.values)
        end
      end
    end

    context 'when processed' do
      before :all do
        @page = SpecHelper::GetPage.process(:bro_no => 1)
      end

      it 'should expand the URI template' do
        @page.response.uri.should == 'http://bros.local/bros/1'
      end

      it 'should emit expected values' do
        @page.bro_no.should == 1
        @page.name.should == 'Carsten'
        @page.desc.should == 'Carsten is a bro.'
      end

      it 'should emit a hash of expected values' do
        hsh = @page.as_hash
        hsh[:bro_no].should == 1
        hsh[:name].should == 'Carsten'
        hsh[:desc].should == 'Carsten is a bro.'
      end
    end
  end

  describe SpecHelper::PostPage do
    it 'should overide the default get http method with post' do
      SpecHelper::PostPage.http_method.should == :post
    end

    context 'when processed' do
      before :all do
        @page = SpecHelper::PostPage.process(nil, :q => 'test', :type => 'test')
      end

      it 'should overide default body params with provided params' do
        @page.body_params[:q].should == 'test'
        @page.body_params[:type].should == 'test'
      end

      it 'should have a valid uri template' do
        @page.response.uri.should == 'http://bros.local/search'
      end

      it 'should parse the page' do
        @page.as_hash[:names].should include('Carsten', 'Kieran', 'Kevin')
      end
    end
  end

  describe SpecHelper::EventedPage do
    it 'should override the default http method with PUT' do
      SpecHelper::EventedPage.http_method.should == :put
    end

    context '(instantiated)' do
      before :all do
        @page = SpecHelper::EventedPage.process(:bro_no => 1)
      end

      it 'should fire the included events' do
        @page.before_request.should be_true
        @page.after_request.should be_true
        @page.before_parse.should be_true
        @page.after_parse.should be_true
      end
    end
  end

end
