class User < ActiveRecord::Base
  has_many :stocks, :through => :user_stocks, :validate => false
  has_many :user_stocks
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable
#        :recoverable

  def guest?
    self.role == "guest"
  end
end
