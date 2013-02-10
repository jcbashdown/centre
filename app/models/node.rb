class Node < ActiveRecord::Base
  before_save :set_caches_and_conclusion

  def set_caches_and_conclusion
    self.users_count = ContextNode.count( :conditions => ["#{self.type.gsub("Node::", "").underscore}_id = ?", self.id] )
    self.not_conclusion_votes_count = ContextNode.count( :conditions => ["is_conclusion = false AND #{self.type.gsub("Node::", "").underscore}_id = ?", self.id] )
    self.conclusion_votes_count = ContextNode.count( :conditions => ["is_conclusion = true AND #{self.type.gsub("Node::", "").underscore}_id = ?", self.id] )
    if (self.conclusion_votes_count > self.not_conclusion_votes_count)
      self.is_conclusion = true
    else
      self.is_conclusion = false
    end
    nil
  end

  def opposite_direction
    {"to" => "from", "from" => "to"}
  end

  #alt would be find all links from ids of nodes, map ids of subset of nodes there are links for
  #from result, delete ids from nodes map and construct for rest, slightly more db efficient as group find?
  def find_view_links_by_context direction, context
    other_node = opposite_direction[direction]
    nodes = Node.find_by_context(context.except(:user, :page))
    links = []
    nodes.each do |node|
      unless node == self
        global_link_attrs = {:"global_node_#{direction}_id" => self.id, :"global_node_#{other_node}_id" => node.id}
        link = Link::UserLink.where(global_link_attrs.merge(:user_id => context[:user]))[0].try(:global_link)
        if link
          links << link
        else
          links << Link::GlobalLink.new({:"node_#{direction}_id" => self.id, :"node_#{other_node}_id" => node.id})
        end
      end
    end
    Kaminari.paginate_array(links).page(context[:page]).per(10)
  end

  class << self
    def get_klass conditions
      if conditions[:question] || conditions[:group] || conditions[:user]
        ContextNode
      else
        Node::GlobalNode
      end
    end
    
    def find_by_context conditions
      klass = self.get_klass conditions
      results = klass.search do
        fulltext conditions[:query] if conditions[:query]
        with :question_id, conditions[:question] if conditions[:question]
        with :group_id, conditions[:group] if conditions[:group]
        with :user_id, conditions[:user] if conditions[:user]
        order_by(:id, :asc)
      end.results.map(&:global_node).uniq 
      if conditions[:page]
        Node::GlobalNode.where(:id => results).page(conditions[:page]).per(10)
      else
        Node::GlobalNode.where(:id => results)
      end
    end
    
  end
end

