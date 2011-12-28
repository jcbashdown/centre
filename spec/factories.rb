require 'factory_girl'

Factory.define :node do |n|
  n.title 'Test'
  n.text 'Test text'
end

Factory.define :user do |u|
  u.name 'Test User'
  u.email 'user@test.com'
  u.password 'please'
end
