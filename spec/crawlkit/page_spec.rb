require 'spec_helper'

describe LCBO::CrawlKit::Page do

  it 'should have a collection of emittable fields' do
    f = SpecHelper::GetPage.fields
    f.must_include :bro_no
    f.must_include :name
    f.must_include :desc
    f = SpecHelper::PostPage.fields
    f.must_include :q
    f.must_include :type
    f.must_include :names
    SpecHelper::EventedPage.fields.must_include :message
  end

  describe SpecHelper::GetPage do
    it 'should default to a GET request' do
      SpecHelper::GetPage.http_method.must_equal :get
    end

    describe 'when requested' do
      before do
        @page = SpecHelper::GetPage.request(:bro_no => 1)
      end

      it 'should not be parsed' do
        @page.is_parsed?.must_equal false
      end

      it 'should have a valid response object' do
        @page.response.must_be_instance_of LCBO::CrawlKit::Response
      end

      describe 'the response' do
        before do
          @page.process
        end

        it 'should be directly parsable' do
          page = SpecHelper::GetPage.parse(@page.response)
          @page.as_hash.values.each do |value|
            page.as_hash.values.must_include value
          end
        end

        it 'should be parsable from a hash representation' do
          page = SpecHelper::GetPage.parse(@page.response.as_hash)
          @page.as_hash.values.each do |value|
            page.as_hash.values.must_include value
          end
        end
      end
    end

    describe 'when processed' do
      before do
        @page = SpecHelper::GetPage.process(:bro_no => 1)
      end

      it 'should expand the URI template' do
        @page.response.uri.must_equal 'http://bros.local/bros/1'
      end

      it 'should emit expected values' do
        @page.bro_no.must_equal 1
        @page.name.must_equal 'Carsten'
        @page.desc.must_equal 'Carsten is a bro.'
      end

      it 'should emit a hash of expected values' do
        hsh = @page.as_hash
        hsh[:bro_no].must_equal 1
        hsh[:name].must_equal 'Carsten'
        hsh[:desc].must_equal 'Carsten is a bro.'
      end
    end
  end

  describe SpecHelper::PostPage do
    it 'should overide the default get http method with post' do
      SpecHelper::PostPage.http_method.must_equal :post
    end

    describe 'when processed' do
      before do
        @page = SpecHelper::PostPage.process(nil, :q => 'test', :type => 'test')
      end

      it 'should overide default body params with provided params' do
        @page.body_params[:q].must_equal 'test'
        @page.body_params[:type].must_equal 'test'
      end

      it 'should have a valid uri template' do
        @page.response.uri.must_equal 'http://bros.local/search'
      end

      it 'should parse the page' do
        %w[Carsten Kieran Kevin].each do |name|
          @page.as_hash[:names].must_include name
        end
      end
    end
  end

  describe SpecHelper::EventedPage do
    it 'should override the default http method with PUT' do
      SpecHelper::EventedPage.http_method.must_equal :put
    end

    describe '(instantiated)' do
      before do
        @page = SpecHelper::EventedPage.process(:bro_no => 1)
      end

      it 'should fire the included events' do
        @page.before_request.must_equal true
        @page.after_request.must_equal true
        @page.before_parse.must_equal true
        @page.after_parse.must_equal true
      end
    end
  end

end
