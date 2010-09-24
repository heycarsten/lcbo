require 'spec_helper'

describe LCBO::CrawlKit::Eventable do

  it 'should have three callbacks' do
    SpecHelper::Evented.callbacks.size.must_equal 3
  end

  describe 'upon firing the events' do
    before do
      @evented = SpecHelper::Evented.new
      @evented.request!
    end

    it 'should run all events and fire all callbacks' do
      @evented.requested.must_equal true
      @evented.test_1.must_equal true
      @evented.test_2.must_equal true
      @evented.test_3.must_equal true
    end
  end

end
