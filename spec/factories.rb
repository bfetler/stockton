FactoryGirl.define do
  factory :stock do
#   companyname   "Google"
#   companysymbol "GOOG"
    sequence(:companyname, 'A') { |a| "GooG #{a}" }
    sequence(:companysymbol, 'A') { |a| "GG#{a}" }
    sequence(:value) { |n| "#{n}00" }
    delta         "10"
  end

  factory :user do
    sequence(:email, 'A') { |a| "wilma#{a}@flintstone.com" }
    password  "abc123"
    password_confirmation  "abc123"
  end
end
