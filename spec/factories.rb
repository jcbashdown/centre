require 'factory_girl'

Factory.define :node do |n|
  n.title 'Test'
  n.text 'Test text'
end

Factory.define :global do |n|
  n.name 'Test'
end

Factory.define :user do |u|
  u.name 'Test User'
  u.email 'user@test.com'
  u.password 'please'
end

Factory.define :nodes_global do |ng|
end
