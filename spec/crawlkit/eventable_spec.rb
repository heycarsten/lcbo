require 'spec_helper'

describe LCBO::CrawlKit::Eventable, 'when mixed into a class' do

  it 'should have three callbacks' do
    SpecHelper::Evented.callbacks.size.should == 3
  end

  context 'upon firing the events' do
    before :all do
      @evented = SpecHelper::Evented.new
      @evented.request!
    end

    it 'should run all events and fire all callbacks' do
      @evented.requested.should be_true
      @evented.test_1.should be_true
      @evented.test_2.should be_true
      @evented.test_3.should be_true
    end
  end

end
