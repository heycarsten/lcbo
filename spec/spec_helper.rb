gem 'rspec', '1.3.0'

require 'spec'
require 'lcbo'

BRO_HTML        = '<h1>Carsten</h1><p>Carsten is a bro.</p>'
BRO_SEARCH_HTML = '<ul><li>Carsten</li><li>Kevin</li><li>Kieran</li></ul>'

def hydrastub(method, uri, response_opts = {})
  response_params = {
    :code => 200,
    :headers => '',
    :body => '',
    :time => 0.3
  }.merge(response_opts)
  response = Typhoeus::Response.new(response_params)
  Typhoeus::Hydra.hydra.stub(method, uri).and_return(response)
end

hydrastub :get,  /http\:\/\/bros\.local\/bros\/.+/, :body => BRO_HTML
hydrastub :post, /http\:\/\/bros\.local\/search/,   :body => BRO_SEARCH_HTML

module SpecHelper

  class GetPage
    include LCBO::CrawlKit::Page
    uri 'http://bros.local/bros/{bro_no}'
    emits(:bro_no) { query[:bro_no].to_i }
    emits(:name)   { doc.css('h1')[0].content }
    emits(:desc)   { doc.css('p')[0].content  }
  end

  class PostPage
    include LCBO::CrawlKit::Page
    http_method :post
    uri 'http://bros.local/search'
    default_params :q => '', :type => 'all'
    emits(:q)     { params[:q].to_s }
    emits(:type)  { params[:type].to_s }
    emits(:names) { doc.css('li').map(&:content) }
  end

end
