require 'rails_helper'
# require 'webmock/rspec'
  require 'net/http'
# WebMock.allow_net_connect!  # enables http in other files

# just delete this spec?  1/15/13
# originally this was for testing fake_request() and random values

describe "Randomize StockService" do
  before(:all) do
    @stocka = FactoryGirl.create(:stock)
  end
  after(:all) do
    Stock.all.each { |s| s.destroy }
  end
# before(:each) do
#   WebMock.allow_net_connect!
# end
# after(:each) do
#   WebMock.disable_net_connect!
# end

# let(:stocka) { FactoryGirl.build(:stock) }
# let(:stocks) { 3.times.each.map { FactoryGirl.create(:stock) } }

  describe "should randomize stock:" do
    before(:each) do
      @old_stock = Stock.first
      StockService.fake_request()
      @new_stock = Stock.first
      @delta_max = 5.0
    end
    
    it "value less than old plus delta" do
      @new_stock.value.to_f.should be <= @old_stock.value.to_f + @delta_max
    end
    it "value more than old minus delta" do
      @new_stock.value.to_f.should be >= @old_stock.value.to_f - @delta_max
    end
    it "delta less than +max" do
      @new_stock.delta.to_f.should be <=    @delta_max
    end
    it "delta more than -max" do
      @new_stock.delta.to_f.should be >=  - @delta_max
    end
  end

  it "should add 3 stocks to db" do
    lambda do
      3.times.each.map { FactoryGirl.create(:stock) }
    end.should change(Stock, :count).by(3)
    3.times.each { Stock.last.destroy }
  end
  
  it "should add 3 stocks with delta 10" do
    stocks = 3.times.each.map { FactoryGirl.create(:stock) }
    Stock.all.each do |s|
      s.delta.to_f.should eq(10.0)
    end
  end
  
  it "should randomize all stocks" do
    stocks = 3.times.each.map { FactoryGirl.create(:stock) }
    stocks_hash = StockService.randomize_stocks()
    stocks_hash.each do |index, s|
      s["delta"].to_f.should be <=   5.0
      s["delta"].to_f.should be >=  -5.0
    end
    3.times.each { Stock.last.destroy }
  end
  
  it "should randomize 3 stocks" do
    stocks = 3.times.each.map { FactoryGirl.create(:stock) }
    stocks_hash = StockService.randomize_stocks(*stocks)  # pass Array as variable number of args
    stocks_hash.count.should eq(3)
    stocks_hash.each do |index, s|
      s["delta"].to_f.should be <=   5.0
      s["delta"].to_f.should be >=  -5.0
    end
    3.times.each { Stock.last.destroy }
  end
  
  it "should save all randomized stocks in db" do
    stocks = 3.times.each.map { FactoryGirl.create(:stock) }
    StockService.fake_request()
    Stock.all.each do |s|
      s.delta.to_f.should be <=   5.0
      s.delta.to_f.should be >=  -5.0
    end
    3.times.each { Stock.last.destroy }
  end

end
