require "#{Rails.root}/lib/conclusion.rb"

class QuestionConclusion < ActiveRecord::Base
  extend Conclusion

  attr_accessible :global_node_id, :question_id

  belongs_to :question
  belongs_to :conclusion, :foreign_key => :global_node_id, :class_name => Node::GlobalNode
end
