require 'spec_helper'

describe LCBO::CrawlKit::Eventable, 'when mixed into a class' do

  class Evented
    include LCBO::CrawlKit::Eventable
    on :before_request, :test_method
    attr_reader :test_called
    def test_method; @test_called = true; end
  end

  it 'should have one callback' do
    Evented.callbacks.size.should == 1
  end

  it 'should call the associated callback method when firing an event' do
    @evented = Evented.new
    @evented.fire(:before_request)
    @evented.test_called.should be_true
  end

end
