require 'spec_helper'

describe LCBO do
  describe 'configuration' do
    it 'should be a hash' do
      LCBO.config.must_be_instance_of Hash
    end

    it 'should be configurable' do
      LCBO.config[:user_agent] = 'Test'
      LCBO.config[:user_agent].must_equal 'Test'
      LCBO.reset_config!
      LCBO.config[:user_agent].must_be_nil
    end
  end

  describe 'helper methods' do
    it 'provides LCBO.parse' do
      LCBO.must_respond_to :parse
    end

    it 'provides LCBO.product' do
      LCBO.must_respond_to :product
    end

    it 'provides LCBO.store' do
      LCBO.must_respond_to :store
    end

    it 'provides LCBO.inventory' do
      LCBO.must_respond_to :inventory
    end

    it 'provides LCBO.product_list' do
      LCBO.must_respond_to :product_list
    end
  end
end
