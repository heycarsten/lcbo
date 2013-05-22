require 'spec_helper'

describe BCL do
  describe 'configuration' do
    it 'should be a hash' do
      BCL.config.must_be_instance_of Hash
    end

    it 'should be configurable' do
      BCL.config[:user_agent] = 'Test'
      BCL.config[:user_agent].must_equal 'Test'
      BCL.reset_config!
      BCL.config[:user_agent].must_be_nil
    end
  end

  describe 'helper methods' do
    it 'provides BCL.parse' do
      BCL.must_respond_to :parse
    end

    it 'provides BCL.product' do
      BCL.must_respond_to :product
    end

    it 'provides BCL.store' do
      BCL.must_respond_to :store
    end

    it 'provides BCL.inventory' do
      BCL.must_respond_to :inventory
    end

    it 'provides BCL.product_list' do
      BCL.must_respond_to :product_list
    end
  end
end

require 'bcl_pages_spec'