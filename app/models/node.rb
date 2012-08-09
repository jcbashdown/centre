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

  self << class
    def get_class conditions
      if conditions[:question_id] && conditions[:user_id]
        ContextNode
      elsif conditions[:question_id]
        Node::QuestionNode
      elsif conditions[:user_id]
        Node::UserNode
      else
        Node::GlobalNode
      end
    end
    
    def search conditions, query = nil
      klass = get_class
      klass.search do
        fulltext query if query
        with :question_id, conditions[:question_id] if conditions[:question_id]
        with :user_id, conditions[:user_id] if conditions[:user_id]
        order_by(:id, :asc)
        paginate(:page => params[:page], :per_page => 15)
      end.results
    end
    
  end
end

