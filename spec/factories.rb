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
    email 'user@test.com'
    password 'please'
  end
  
end
