class Link::QuestionLink < Link
  belongs_to :question_node_from, :foreign_key => :node_from_id, :class_name => Node::QuestionNode
  belongs_to :question_node_to, :foreign_key => :node_to_id, :class_name => Node::QuestionNode
  belongs_to :global_link

  class << self
    def update_active(gn_from, gn_to, question)
      unless (current_active = active(gn_from, gn_to, question)) == (by_votes = active_by_votes(gn_from, gn_to, question))
        current_active.update_attributes(:active => false) if current_active
        by_votes.update_attributes(:active => true)
      end
    end
  
    def active_by_votes(gn_from, gn_to, question)
      where(:global_node_from_id => gn_from, :global_node_to_id => gn_to, :question_id => question).order(:users_count).last
    end
    def active(gn_from, gn_to, question)
      where(:global_node_from_id => gn_from, :global_node_to_id => gn_to, :active => true, :question_id => question).last
    end
  end
end
