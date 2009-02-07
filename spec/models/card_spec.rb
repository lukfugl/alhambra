require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Card do
  before(:each) do
  end

  it "should have a CURRENCIES constant with the four currencies" do
    Card::CURRENCIES.size.should be(4)
    Card::CURRENCIES.should include('florin')
    Card::CURRENCIES.should include('dirham')
    Card::CURRENCIES.should include('denar')
    Card::CURRENCIES.should include('dukat')
  end
end
