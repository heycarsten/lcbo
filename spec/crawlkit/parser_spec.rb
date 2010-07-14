require 'spec_helper'

describe LCBO::CrawlKit::Parser, 'when mixed into a class' do

  class BroParser
    include LCBO::CrawlKit::Parser
    emits :name
    def name; doc.css('.name')[0].content; end
    def id; params[:id]; end
  end

  def bro_html
    '<ul><li class="name">Brosten</li><li>Test Node</li></ul>'
  end

  def bro_json(html)
    %({"params":{"id":1},"body":#{html.inspect}})
  end

  def bro_request(html)
    request = mock(:request, :body => html, :params => { :id => 1 })
  end

  it 'should parse a bro via Request' do
    bro = BroParser.from_request(bro_request(bro_html))
    bro.name.should == 'Brosten'
    bro.id.should == 1
  end

  it 'should parse a bro via JSON' do
    bro = BroParser.from_json(bro_json(bro_html))
    bro.name.should == 'Brosten'
    bro.id.should == 1
  end

end
