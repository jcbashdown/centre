require 'factory_girl'
FactoryGirl.define do

  factory :user do
    name 'Test User'
    sequence(:email) { |n| "factory_test#{n}_#{Time.now.to_i}@email.addresss" }
    password 'please'
  end

end
