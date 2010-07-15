gem 'rspec', '1.3.0'

require 'spec'
require 'lcbo'

BRO_HTML = '<h1>Carsten</h1><p>Carsten is a bro.</p>'
BRO_SEARCH_HTML = '<ul><li>Carsten</li><li>Kevin</li><li>Kieran</li></ul>'

def stub_hydra(method, url, response_opts = {})
  response_params = {
    :code => 200,
    :headers => '',
    :body => '',
    :time => 0.3
  }.merge(response_opts)
  hydra = Typhoeus::Hydra.hydra
  response = Typhoeus::Response.new(response_params)
  hydra.stub(method, url).and_return(response)
end

stub_hydra :get,  'http://bros.local/bros/1', :body => BRO_HTML
stub_hydra :post, 'http://bros.local/search', :body => BRO_SEARCH_HTML

module SpecHelper

  class BroRequest
    include LCBO::CrawlKit::Request
    uri_template 'http://bros.local/bros/{id}'
  end

  class BroParser
    include LCBO::CrawlKit::Parser
    emits :name, :id
    def name; doc.css('h1')[0].content; end
    def id; params[:id]; end
  end

  class BroSearchRequest
    include LCBO::CrawlKit::Request
    uri_template 'http://bros.local/search'
    body_params :a => 'test-a', :b => 'test-b'
  end

  class BroSearchParser
    include LCBO::CrawlKit::Parser
    emits :names
    def names; doc.css('li').map(&:content); end
  end

end
