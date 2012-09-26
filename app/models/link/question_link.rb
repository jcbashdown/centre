class Link::QuestionLink < Link
  belongs_to :question_node_from, :foreign_key => :node_from_id, :class_name => Node::QuestionNode
  belongs_to :question_node_to, :foreign_key => :node_to_id, :class_name => Node::QuestionNode
  belongs_to :global_link

  class << self
    def update_active(question)
      unless (current_active = active(question)) == (by_votes = active_by_votes(question))
        current_active.update_attributes(:active => false) if current_active
        by_votes.update_attributes(:active => true)
      end
    end
  
    def active_by_votes(question)
      where(:question_id => question.id).order(:users_count).last
    end
    def active(question)
      where(:active => true, :question_id => question).last
    end
  end
end
