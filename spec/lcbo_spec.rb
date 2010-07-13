require 'spec_helper'

describe LCBO do
  it 'has configuration' do
    LCBO.config[:user_agent].should be_nil
  end
end
