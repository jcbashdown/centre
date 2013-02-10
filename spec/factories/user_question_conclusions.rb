# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_question_conclusion do
    user_id 1
    question_id 1
    global_node_id 1
  end
end
