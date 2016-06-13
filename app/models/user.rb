class User < ActiveRecord::Base
  has_many :stocks, :through => :user_stocks, :validate => false
  has_many :user_stocks
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable
#        :recoverable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  attr_accessible :role
  
  def guest?
    self.role == "guest"
  end
end
