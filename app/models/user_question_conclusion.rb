require "#{Rails.root}/lib/conclusion.rb"

class UserQuestionConclusion < ActiveRecord::Base
  extend Conclusion

  attr_accessible :global_node_id, :question_id, :user_id

  belongs_to :user
  belongs_to :question
  belongs_to :conclusion, :foreign_key => :global_node_id, :class_name => Node::GlobalNode
end
