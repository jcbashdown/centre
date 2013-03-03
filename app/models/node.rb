class Node < ActiveRecord::Base
  before_save :set_caches_and_conclusion

  def set_caches_and_conclusion
    self.users_count = ContextNode.count( :conditions => ["#{self.type.gsub("Node::", "").underscore}_id = ?", self.id] )
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
      if conditions[:question] || conditions[:user_ids] || conditions[:user]
        ContextNode
      else
        Node::GlobalNode
      end
    end

    def find_by_context conditions
      results = find_ids_by_context(conditions).map(&:global_node_id).uniq 
      if conditions[:page]
        Node::GlobalNode.where(:id => results).page(conditions[:page]).per(10)
      else
        Node::GlobalNode.where(:id => results)
      end
    end
    
    def find_ids_by_context conditions
      #.results could be .hits if don't need to get from db (just get from solr index)
      binding.pry
      results = ContextNode.search do
        fulltext conditions[:query] if conditions[:query]
        with :global_node_id, conditions[:global_node_id] if conditions[:global_node_id]
        with :question_id, conditions[:question] if conditions[:question]
        with :user_id, conditions[:user] if conditions[:user]
        with(:user_id).any_of conditions[:user_ids] if conditions[:user_ids].try(:any?)#proxy for group
        with :is_conclusion, conditions[:is_conclusion] if conditions[:is_conclusion]
        order_by(:id, :asc)
      end.results
      p conditions
      p ContextNode.all
      p results
      results
    end
    
  end
end

