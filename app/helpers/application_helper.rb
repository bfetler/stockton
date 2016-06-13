module ApplicationHelper

  def is_admin?
    #if !current_user.admin?
    #  redirect_to :controller => :stocks, :action => :index
    #end
    current_user.admin?
  end
  
  def is_in_user_stocklist?(stock)
    in_stocklist = current_user.stocks.select do |s|
      s.companysymbol == stock.companysymbol
    end
    in_stocklist.any?
  end

  def guest_user
    guest = User.where("role = ?", "guest").first
    #guest = User.where("email = ?", "guest@stockton.com").first
    if guest.nil?
      guest = create_guest_user
    end
    guest
  end
  
  def create_guest_user
    attrs = { :email => "guest@stockton.com",
                :password => "abc234",
                :password_confirmation => "abc234",
                :role => "guest" }
    u = User.new(attrs)
    u.save!
    User.where("role = ?", "guest").first
  end

end
