require "#{Rails.root}/lib/conclusion.rb"

class QuestionConclusion < ActiveRecord::Base
  extend Conclusion

  attr_accessible :global_node_id, :question_id
end
