require 'rails_helper'

describe "Integration: Users" do

  describe "Create User" do
    describe "failure" do
      it "should not create a new user" do
        lambda do
#         visit 'root'
          visit root_path
          click_link "Create New User"
          fill_in "Email",      :with => ""
          fill_in "Password",   :with => ""
          fill_in "Password confirmation",   :with => ""
          click_button "Create New User"
        end.should_not change(User, :count)
      end

      it "should have new user errors" do
        visit root_path
        click_link "Create New User"
        fill_in "Email",      :with => ""
        fill_in "Password",   :with => ""
        fill_in "Password confirmation",   :with => ""
        click_button "Create New User"
        page.should have_selector("div#error_explanation")
        page.should have_selector("div#error_explanation li", :text => "Email can't be blank")
        page.should have_selector("div#error_explanation li", :text => "Password can't be blank")
        page.should have_content("Email can't be blank")
        page.should have_content("Password can't be blank")
      end
    end

    describe "success" do
      it "should create a new user" do
        lambda do
#         visit 'users/sign_in'
          visit root_path
          click_link "Create New User"
          fill_in "Email",      :with => "george@jetson.com"
          fill_in "Password",   :with => "jaaaane"
          fill_in "Password confirmation",   :with => "jaaaane"
          click_button "Create New User"
        end.should change(User, :count).by(1)
      end

      it "should show stock table" do
#       visit 'users/sign_in'
        visit root_path
        click_link "Create New User"
        fill_in "Email",      :with => "george@jetson.com"
        fill_in "Password",   :with => "jaaaane"
        fill_in "Password confirmation",   :with => "jaaaane"
        click_button "Create New User"
        page.should have_selector("div.main_panel")
        page.should have_selector("table.stock_panel")
        page.should have_selector("div.action_panel")
      end
    end
  end

  describe "User Login" do

    before { @user = FactoryGirl.create(:user) }

    describe "failure" do
      it "should not log in an invalid user" do
        lambda do
          visit root_path
          fill_in "Email",      :with => ""
          fill_in "Password",   :with => ""
          click_button "Sign In"
        end.should_not change(User, :count)
      end

      it "should show error message for invalid user" do
        visit root_path
        fill_in "Email",      :with => ""
        fill_in "Password",   :with => ""
        click_button "Sign In"
        page.should have_selector("p", :text => "Invalid email or password.")
        page.should have_content("Invalid email or password.")
      end
    end

    describe "success" do
      it "should log in a factory user" do
        lambda do
          visit root_path
          fill_in "Email",      :with => @user.email
          fill_in "Password",   :with => @user.password
          click_button "Sign In"
        end.should_not change(User, :count)
      end

      it "should show stock table for a factory user" do
        visit root_path
        fill_in "Email",      :with => @user.email
        fill_in "Password",   :with => @user.password
        click_button "Sign In"
        page.should have_selector("div.main_panel")
        page.should have_selector("table.stock_panel")
        page.should have_selector("div.action_panel")
      end
    end

  end
  
  describe "Guest Login" do
    it "should create guest user" do
      lambda do
        visit root_path
        click_button "Guest Sign In"
      end.should change(User, :count).by(1)
    end
    
    it "should show stock table for guest user" do
      visit root_path
      click_button "Guest Sign In"
      page.should have_selector("div.main_panel")
      page.should have_selector("table.stock_panel")
      page.should have_selector("div.action_panel")
    end
  end

end
