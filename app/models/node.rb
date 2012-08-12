class Node < ActiveRecord::Base
  before_save :set_caches_and_conclusion
  def set_caches_and_conclusion
    self.users_count = ContextNode.count( :conditions => ["#{self.type.gsub("Node::", "").underscore}_id = ?", self.id] )
    self.conclusion_votes_count = ContextNode.count( :conditions => ["is_conclusion = true AND #{self.type.gsub("Node::", "").underscore}_id = ?", self.id] )
    if self.conclusion_votes_count > (self.users_count/2)
      self.is_conclusion = true
    else
      self.is_conclusion = false
    end
    nil
  end

  class << self
    def get_klass conditions
      if conditions[:nodes_question] && conditions[:nodes_user]
        ContextNode
      elsif conditions[:nodes_question]
        Node::QuestionNode
      elsif conditions[:nodes_user]
        Node::UserNode
      else
        Node::GlobalNode
      end
    end
    
    def find_by_context conditions
      klass = self.get_klass conditions
      klass.search do
        fulltext conditions[:nodes_query] if conditions[:nodes_query]
        with :question_id, conditions[:nodes_question] if conditions[:nodes_question]
        with :user_id, conditions[:nodes_user] if conditions[:nodes_user]
        order_by(:id, :asc)
        paginate(:page => conditions[:page], :per_page => 15) if conditions[:page]
      end.results
    end
    
  end
end

