require "#{Rails.root}/lib/conclusion.rb"

class GroupQuestionConclusion < ActiveRecord::Base
  extend Conclusion

  attr_accessible :global_node_id, :group_id, :question_id
end
