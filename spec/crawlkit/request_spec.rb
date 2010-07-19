require 'spec_helper'

# See spec_helper.rb for example Request classes.
describe LCBO::CrawlKit::Request do

  it 'should have an assoicated parser' do
    SpecHelper::BroRequest.parser.should == SpecHelper::BroParser
  end

  it 'should have a URI template' do
    SpecHelper::BroRequest.uri_template.should be_a(Addressable::Template)
  end

  it 'should parse a bro' do
    SpecHelper::BroRequest.parse(:id => 1).as_hash[:name].should == 'Carsten'
  end

  it 'should find bros' do
    SpecHelper::BroSearchRequest.parse.as_hash[:names].size.should == 3
  end

end


class StorePage

  include SyncKit::Page

  uri_template 'http://lcbo.com/assfaces/{id}'

  params :page => 1, :cool => 'no'

  emits :name

end
