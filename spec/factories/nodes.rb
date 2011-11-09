require 'factory_girl'

FactoryGirl.define do 
  Factory :node do 
    name 'Test User'
    email 'user@test.com'
    password 'please'
  end
end

