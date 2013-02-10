require "#{Rails.root}/lib/conclusion.rb"

class UserQuestionConclusion < ActiveRecord::Base
  extend Conclusion

  attr_accessible :global_node_id, :question_id, :user_id
end
