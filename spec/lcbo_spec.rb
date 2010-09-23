require 'spec_helper'

describe LCBO do
  context 'configuration' do
    it 'should be a hash' do
      LCBO.config.should be_a(Hash)
    end

    it 'should be configurable' do
      LCBO.config[:user_agent] = 'Test'
      LCBO.config[:user_agent].should == 'Test'
      LCBO.reset_config!
      LCBO.config[:user_agent].should be_nil
    end
  end

  context 'helper methods' do
    it 'provides LCBO.parse' do
      LCBO.should respond_to(:parse)
    end

    it 'provides LCBO.product' do
      LCBO.should respond_to(:product)
    end

    it 'provides LCBO.store' do
      LCBO.should respond_to(:store)
    end

    it 'provides LCBO.inventory' do
      LCBO.should respond_to(:inventory)
    end

    it 'provides LCBO.product_list' do
      LCBO.should respond_to(:product_list)
    end
  end
end
