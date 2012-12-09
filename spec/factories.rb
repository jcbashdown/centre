require 'factory_girl'
FactoryGirl.define do

  factory :node do
    title 'Test'
    body 'Test text'
  end
  
  factory :question do
    name 'Test'
  end
  
  factory :user do
    name 'Test User'
    sequence(:email) { |n| "factory_test#{n}_#{Time.now.to_i}@email.addresss" }
    password 'please'
  end
  
end
