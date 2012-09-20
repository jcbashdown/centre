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

  # can change all to question, user, query etc but how to do cookies or translate
  def find_view_links_from_by_context context
    find_view_links_by_context :from, context
    #find nodes meeting criteria as below
    #for each node that isn't self, find or construct link
    #--
    #alt would be find all links from ids of nodes, map ids of subset of nodes there are links for
    #from result, delete ids from nodes map and construct for rest, slightly more db efficient as group find?
  end

  def find_view_links_to_by_context context
    find_view_links_by_context :to, context
    
  end

  def find_view_links_by_context direction, context
    nodes = Node.find_by_context(context)
    links = []
    nodes.each do |node|
      
    end
  end

  class << self
    def get_klass conditions
      if conditions[:question] && conditions[:user]
        ContextNode
      elsif conditions[:question]
        Node::QuestionNode
      elsif conditions[:user]
        Node::UserNode
      else
        Node::GlobalNode
      end
    end
    
    def find_by_context conditions
      klass = self.get_klass conditions
      klass.search do
        fulltext conditions[:query] if conditions[:query]
        with :question_id, conditions[:question] if conditions[:question]
        with :user_id, conditions[:user] if conditions[:user]
        order_by(:id, :asc)
        paginate(:page => conditions[:page], :per_page => 15) if conditions[:page]
      end.results.map(&:global_node)
    end
    
  end
end

