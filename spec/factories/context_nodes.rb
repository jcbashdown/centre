require 'factory_girl'
FactoryGirl.define do

  factory :context_node do
    title 'Test'
    user
    question
  end

end
