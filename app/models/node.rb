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
    find_view_links_by_context "from", "to", context
    #find nodes meeting criteria as below
    #for each node that isn't self, find or construct link
    #--
    #alt would be find all links from ids of nodes, map ids of subset of nodes there are links for
    #from result, delete ids from nodes map and construct for rest, slightly more db efficient as group find?
  end

  def find_view_links_to_by_context context
    find_view_links_by_context "to", "from", context
  end

  def find_view_links_by_context direction, this_node, context, pry=false
    if pry
      binding.pry
    end
    nodes = Node.find_by_context(context)
    links = []
    nodes.each do |node|
      klass = Link.get_klass(context)
      global_link_attrs = {:"global_node_#{direction}_id" => node.id, :"global_node_#{this_node}_id" => self.id}
      global_link_attrs.merge!({:active => true}) if (klass == Link::GlobalLink || klass == Link::QuestionLink)
      if klass == ContextLink
        link = klass.where(global_link_attrs.merge(:question_id => context[:question], :user_id => context[:user]))[0].try(:global_link)
      elsif klass == Link::QuestionLink 
        link = klass.where(global_link_attrs.merge(:question_id => context[:question]))[0].try(:global_link)
      elsif klass == Link::UserLink
        link = klass.where(global_link_attrs.merge(:user_id => context[:user]))[0].try(:global_link)
      else
        link = klass.where({:"node_#{direction}_id" => node.id, :"node_#{this_node}_id" => self.id})[0]
      end
      if link
        links << link
      else
        links << Link::GlobalLink.new({:"node_#{direction}_id" => node.id, :"node_#{this_node}_id" => self.id})
      end
    end
    links
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

