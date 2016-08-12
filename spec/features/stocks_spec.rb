require 'rails_helper'

describe "Integration: Stocks" do
  
  before(:each) do
    WebMock.allow_net_connect!
    
    @user = FactoryGirl.create(:user)
    visit root_path
    fill_in "Email",      :with => @user.email
    fill_in "Password",   :with => @user.password
    click_button "Sign In"
  end
  
  after(:each) do
    WebMock.disable_net_connect!
  end

  describe "Add Stocks" do
    
    describe "failure" do
      
      it "cannot add empty stock" do
        visit stocks_path
        click_button "Add a Stock"
        fill_in "stock_companysymbol", :with => ""
        click_button "Add New Stock"
        page.should have_selector("div#error_explanation")
        page.should have_selector("div#error_explanation li", :text => "Invalid stock symbol syntax")
        page.should have_content("Invalid stock symbol syntax")
#       expect(page).to have_selector("div#error_explanation")
#       expect(page).to have_selector("div#error_explanation li", :text => "Invalid stock symbol syntax")
#       expect(page).to have_content("Invalid stock symbol syntax")
        @user.stocks.count.should be(0)
      end
      
      it "adding empty stock does not create stock" do
        lambda do
          visit stocks_path
          click_button "Add a Stock"
          fill_in "stock_companysymbol", :with => ""
          click_button "Add New Stock"
        end.should_not change(Stock, :count)
      end
      
      it "adding empty stock does not create user_stock" do
        lambda do
          visit stocks_path
          click_button "Add a Stock"
          fill_in "stock_companysymbol", :with => ""
          click_button "Add New Stock"
        end.should_not change(UserStock, :count)
      end
      
      it "cannot add non-existent stock" do
        visit stocks_path
        click_button "Add a Stock"
        fill_in "stock_companysymbol", :with => "ZYX"
        click_button "Add New Stock"
        page.should have_selector("div#error_explanation")
        page.should have_selector("div#error_explanation li", :text => "Invalid stock symbol")
        page.should have_content("Invalid stock symbol")
      end
      
      it "adding non-existent stock does not create stock" do
        lambda do
          visit stocks_path
          click_button "Add a Stock"
          fill_in "stock_companysymbol", :with => "ZYX"
          click_button "Add New Stock"
        end.should_not change(Stock, :count)
      end
      
      it "adding non-existent stock does not create user_stock" do
        lambda do
          visit stocks_path
          click_button "Add a Stock"
          fill_in "stock_companysymbol", :with => "ZYX"
          click_button "Add New Stock"
        end.should_not change(UserStock, :count)
      end
      
      it "cannot add stock with extra characters" do
        visit stocks_path
        click_button "Add a Stock"
        fill_in "stock_companysymbol", :with => "ASDFG"
        click_button "Add New Stock"
        page.should have_selector("div#error_explanation")
        page.should have_selector("div#error_explanation li", :text => "Invalid stock symbol")
        page.should have_content("Invalid stock symbol")
      end
      
    end  #failure

    describe "success" do
      
      describe "adding one new stock" do
        it "should add stock" do
          visit stocks_path
          click_button "Add a Stock"
          fill_in "stock_companysymbol", :with => "GOOG"
          click_button "Add New Stock"
          page.should have_selector("div.main_panel")
          page.should have_selector("table.stock_panel")
          page.should have_selector("div.action_panel")
          page.should have_content("GOOG")
          page.should have_content("Alphabet Inc.")
          @user.stocks.count.should be(1)
        end
        
        it "should create stock" do
          lambda do
            visit stocks_path
            click_button "Add a Stock"
            fill_in "stock_companysymbol", :with => "GOOG"
            click_button "Add New Stock"
          end.should change(Stock, :count).by(1)
        end
        
        it "should create user_stock" do
          lambda do
            visit stocks_path
            click_button "Add a Stock"
            fill_in "stock_companysymbol", :with => "GOOG"
            click_button "Add New Stock"
          end.should change(UserStock, :count).by(1)
        end
      end    # add one new stock
      
      describe "adding two new stocks" do
        it "should add stocks" do
          visit stocks_path
          click_button "Add a Stock"
          fill_in "stock_companysymbol", :with => "GOOG"
          click_button "Add New Stock"
          click_button "Add a Stock"
          fill_in "stock_companysymbol", :with => "YHOO"
          click_button "Add New Stock"
          page.should have_selector("div.main_panel")
          page.should have_selector("table.stock_panel")
          page.should have_selector("div.action_panel")
          page.should have_content("GOOG")
          page.should have_content("YHOO")
          page.should have_content("Alphabet Inc.")
          page.should have_content("Yahoo! Inc")
          @user.stocks.count.should be(2)
        end
        
        it "should create stocks" do
          lambda do
            visit stocks_path
            click_button "Add a Stock"
            fill_in "stock_companysymbol", :with => "GOOG"
            click_button "Add New Stock"
            click_button "Add a Stock"
            fill_in "stock_companysymbol", :with => "YHOO"
            click_button "Add New Stock"
          end.should change(Stock, :count).by(2)
        end
        
        it "should create user_stocks" do
          lambda do
            visit stocks_path
            click_button "Add a Stock"
            fill_in "stock_companysymbol", :with => "GOOG"
            click_button "Add New Stock"
            click_button "Add a Stock"
            fill_in "stock_companysymbol", :with => "YHOO"
            click_button "Add New Stock"
          end.should change(UserStock, :count).by(2)
        end
      end  # adding two new stocks
      
      describe "add new and duplicate stocks" do
        before(:each) do
          visit stocks_path
          click_button "Add a Stock"
          fill_in "stock_companysymbol", :with => "GOOG"
          click_button "Add New Stock"
        end
        
        it "should add new stock to page" do
          click_button "Add a Stock"
          fill_in "stock_companysymbol", :with => "GOOG"
          click_button "Add New Stock"
          page.should have_selector("div.main_panel")
          page.should have_selector("table.stock_panel")
          page.should have_selector("div.action_panel")
          page.should have_content("GOOG")
          @user.stocks.count.should be(1)
        end
        
        it "should not create duplicate stock" do
          lambda do
            visit stocks_path
            click_button "Add a Stock"
            fill_in "stock_companysymbol", :with => "GOOG"
            click_button "Add New Stock"
          end.should_not change(Stock, :count)
        end
        
        it "should not create duplicate user_stock" do
          lambda do
            click_button "Add a Stock"
            fill_in "stock_companysymbol", :with => "GOOG"
            click_button "Add New Stock"
          end.should_not change(UserStock, :count)
        end
      end    #new & duplicate stocks
      
    end  #success

  end  # Add Stocks
  
  describe "Clear My Stocks" do
    
    before(:each) do
      visit stocks_path
      click_button "Add a Stock"
      fill_in "stock_companysymbol", :with => "GOOG"
      click_button "Add New Stock"
    end
    
    it "should start with one stock" do
      page.should have_selector("div.main_panel")
      page.should have_selector("table.stock_panel")
      page.should have_selector("div.action_panel")
      page.should have_content("GOOG")
      @user.stocks.count.should be(1)
    end
    
    it "should remove user stocks from page" do
      click_button("Clear My Stocks")
      page.should have_selector("div.main_panel")
      page.should have_selector("table.stock_panel")
      page.should have_selector("div.action_panel")
      page.should_not have_content("GOOG")
      @user.stocks.count.should be(0)
    end
    
    it "should not delete stocks" do
      lambda do
        click_button("Clear My Stocks")
      end.should_not change(Stock, :count)
    end
    
    it "should delete user_stocks" do
      lambda do
        click_button("Clear My Stocks")
      end.should change(UserStock, :count).by(-1)
    end
    
  end  # Clear My Stocks

end
