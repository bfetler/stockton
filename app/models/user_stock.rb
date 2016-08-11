class UserStock < ActiveRecord::Base
  belongs_to :user
  belongs_to :stock
# attr_accessible :user_id, :stock_id
end
