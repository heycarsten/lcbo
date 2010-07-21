require 'spec_helper'

describe LCBO::CrawlKit::Page do

  it 'should have a collection of emittable fields' do
    SpecHelper::GetPage.fields.should include(:bro_no, :name, :desc)
    SpecHelper::PostPage.fields.should include(:q, :type, :names)
    SpecHelper::EventedPage.fields.should include(:message)
  end

  context 'GetPage' do
    it 'should default to a GET request' do
      SpecHelper::GetPage.http_method.should == :get
    end

    context '(instantiated)' do
      before :all do
        @page = SpecHelper::GetPage.request(:bro_no => 1)
      end

      it 'should return an instance of itself' do
        @page.should be_a(SpecHelper::GetPage)
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

  context 'PostPage' do
    it 'should overide the default get http method with post' do
      SpecHelper::PostPage.http_method.should == :post
    end

    context '(instantiated)' do
      before :all do
        @page = SpecHelper::PostPage.request(nil, :q => 'test', :type => 'test')
      end

      it 'should overide default body params with provided params' do
        @page.body_params[:q].should == 'test'
        @page.body_params[:type].should == 'test'
      end
    end
  end

  context 'EventedPage' do
    it 'should override the default http method with PUT' do
      SpecHelper::EventedPage.http_method.should == :put
    end

    context '(instantiated)' do
      before :all do
        @page = SpecHelper::EventedPage.request(:bro_no => 1)
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
