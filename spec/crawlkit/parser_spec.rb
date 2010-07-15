require 'spec_helper'

describe LCBO::CrawlKit::Parser, 'when mixed into a class' do

  def bro_json
    %({"params":{"id":1},"body":#{BRO_HTML.inspect}})
  end

  def mock_request
    mock(:request, :body => BRO_HTML, :params => { :id => 1 })
  end

  it 'should parse a bro' do
    bro = SpecHelper::BroParser.new(BRO_HTML, { :id => 1 })
    bro.name.should == 'Carsten'
    bro.id.should == 1
  end

  it 'should parse a bro via Request' do
    bro = SpecHelper::BroParser.from_request(mock_request)
    bro.name.should == 'Carsten'
    bro.id.should == 1
  end

  it 'should parse a bro via JSON' do
    bro = SpecHelper::BroParser.from_json(bro_json)
    bro.name.should == 'Carsten'
    bro.id.should == 1
  end

end
