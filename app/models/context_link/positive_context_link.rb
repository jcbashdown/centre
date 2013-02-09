class ContextLink::PositiveContextLink < ContextLink
 belongs_to :upvoted_group_node_to, :foreign_key => :group_node_to_id, :counter_cache => :upvotes_count, :class_name => Node::GroupNode
end
