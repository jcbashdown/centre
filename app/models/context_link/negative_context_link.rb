class ContextLink::NegativeContextLink < ContextLink
 belongs_to :downvoted_group_node_to, :foreign_key => :group_node_to_id, :counter_cache => :downvotes_count, :class_name => Node::GroupNode
end
