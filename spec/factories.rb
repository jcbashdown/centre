require 'factory_girl'

Factory.define :node do |n|
  n.title 'Test User'
  n.text 'user@test.com'
end

Factory.define :user do |u|
  u.name 'Test User'
  u.email 'user@test.com'
  u.password 'please'
end
