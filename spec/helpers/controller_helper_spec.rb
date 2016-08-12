require 'rails_helper'

describe ControllerHelper do
  
  it "creates a guest user" do
    guest = create_guest_user
    guest.should_not be_nil
  end
  
  it "returns a guest user" do
    guest_user.should_not be_nil
  end
  
  it "adds guest user to database" do
    lambda do
      guest = create_guest_user
    end.should change(User, :count).by(1)
  end
  
  describe "guest user in database" do
    before(:each) do
      guest = create_guest_user
      @u = User.where("role = ?", "guest").first
    end
    
    it "should not be nil" do
      @u.should_not be_nil
    end
    it "should have role 'guest'" do
      @u.role.should eq("guest")
    end
    it "should have guest email" do
      @u.email.should eq("guest@stockton.com")
    end
  end
  
  #describe "user stocklist" do
  #  before(:each) do
  #    @request.env["devise.mapping"] = Devise.mappings[:user]
  #    @attr = { :companyname      => "Google",
  #              :companysymbol    => "GOOG",
  #              :value            => "567.8",
  #              :delta            => "12.3"
  #            }
  #    
  #    @yahoo_attr = { :companyname   => "Yahoo",
  #                    :companysymbol => "YHOO"        
  #    }
  #    
  #    @user = FactoryGirl.create(:user)
  #    sign_in @user
  #    # is_in_user_stocklist?(stock)
  #  end
  #  
  #  it "should not find new stock in current_user" do
  #    stock = Stock.new(@attr)
  #    in_list = is_in_user_stocklist?(stock)
  #    in_list.should be_false
  #  end
  #  
  #end
  
end
