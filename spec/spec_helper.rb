gem 'rspec', '1.3.0'

require 'spec'
require 'lcbo'

BRO_HTML        = '<h1>Carsten</h1><p>Carsten is a bro.</p>'
BRO_SEARCH_HTML = '<ul><li>Carsten</li><li>Kevin</li><li>Kieran</li></ul>'
BRO_ICE_HTML    = '<h1>Bro!</h1><p>You just icy yo fellow bro, dude!</p>'

module SpecHelper

  def self.hydrastub(method, uri, response_opts = {})
    response_params = {
      :code => 200,
      :headers => '',
      :body => '',
      :time => 0.3
    }.merge(response_opts)
    response = Typhoeus::Response.new(response_params)
    Typhoeus::Hydra.hydra.stub(method, uri).and_return(response)
  end

  class Evented
    include LCBO::CrawlKit::Eventable
    on :before_request, :set_test_1
    on :before_request, :set_test_2
    on :after_request,  :set_test_3
    attr_reader :test_1, :test_2, :test_3, :requested
    def set_test_1; @test_1 = true; end
    def set_test_2; @test_2 = true; end
    def set_test_3; @test_3 = true; end
    def request!
      fire(:before_request)
      @requested = true
      fire(:after_request)
    end
  end

  class GetPage
    include LCBO::CrawlKit::Page
    uri 'http://bros.local/bros/{bro_no}'
    emits(:bro_no) { query_params[:bro_no].to_i }
    emits(:name)   { doc.css('h1')[0].content }
    emits(:desc)   { doc.css('p')[0].content  }
  end

  class PostPage
    include LCBO::CrawlKit::Page
    http_method :post
    uri 'http://bros.local/search'
    default_body_params :q => '', :type => 'all'
    emits(:q)     { body_params[:q].to_s }
    emits(:type)  { body_params[:type].to_s }
    emits(:names) { doc.css('li').map(&:content) }
  end

  class EventedPage
    include LCBO::CrawlKit::Page
    attr_reader :before_parse, :after_parse, :before_request, :after_request
    on :before_parse,   :set_before_parse
    on :after_parse,    :set_after_parse
    on :before_request, :set_before_request
    on :after_request,  :set_after_request
    http_method :put
    uri 'http://bros.local/ice/{bro_no}'
    emits(:message) { doc.css('p')[0].content }
    def set_before_parse;   @before_parse   = true; end
    def set_after_parse;    @after_parse    = true; end
    def set_before_request; @before_request = true; end
    def set_after_request;  @after_request  = true; end
  end

end

SpecHelper.hydrastub :get,  /http\:\/\/bros\.local\/bros\/.+/, :body => BRO_HTML
SpecHelper.hydrastub :post, /http\:\/\/bros\.local\/search/,   :body => BRO_SEARCH_HTML
SpecHelper.hydrastub :put,  /http\:\/\/bros\.local\/ice\/.+/,  :body => BRO_ICE_HTML
