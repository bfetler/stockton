require 'rails_helper'

describe UserStock do

  before(:each) do
#   @request.env["devise.mapping"] = Devise.mappings[:user]
    @user   = FactoryGirl.create(:user)
    @user2  = FactoryGirl.create(:user)
    @stock  = FactoryGirl.create(:stock)
    @stock2 = FactoryGirl.create(:stock)
  end

  it "should create user_stock" do
    @attr = { :user_id => @user.id,
              :stock_id => @stock.id
            }
# puts "attr = " + @attr.to_s
    us = UserStock.create!(@attr)
    us.should be_valid
  end

  it "user should have one stock" do
    @user2.stocks << @stock
    @user2.stocks.count.should eq(1)
    UserStock.count.should eq(1)
  end

  it "user should have two stocks" do
    @user2.stocks << @stock
    @user2.stocks << @stock2
    @user2.stocks.count.should eq(2)
    UserStock.count.should eq(2)
  end

  it "user should delete one stock" do
    @user2.stocks << @stock
    @user2.stocks << @stock2
    @user2.stocks.delete(@stock)
    @user2.stocks.count.should eq(1)
    UserStock.count.should eq(1)
  end

  it "users should each have two stocks" do
    @user.stocks << @stock
    @user.stocks << @stock2
    @user2.stocks << @stock
    @user2.stocks << @stock2
    @user.stocks.count.should eq(2)
    @user2.stocks.count.should eq(2)
    @stock.users.count.should eq(2)
    @stock2.users.count.should eq(2)
    UserStock.count.should eq(4)
  end

  it "delete stock - users should each have one stock" do
    @user.stocks << @stock
    @user.stocks << @stock2
    @user2.stocks << @stock
    @user2.stocks << @stock2
    @stock2.users.clear
    @stock2.delete
    @user.stocks.count.should eq(1)
    @user2.stocks.count.should eq(1)
    @stock.users.count.should eq(2)
#   Stock.count.should eq(1)
    UserStock.count.should eq(2)
  end

  it "delete user - user should have two stocks" do
    @user.stocks << @stock
    @user.stocks << @stock2
    @user2.stocks << @stock
    @user2.stocks << @stock2
    @user2.stocks.clear
    @user2.delete
    @user.stocks.count.should eq(2)
    @stock.users.count.should eq(1)
    @stock2.users.count.should eq(1)
#   Stock.count.should eq(2)
    UserStock.count.should eq(2)
  end

end
