class Link::UserLink::NegativeUserLink < Link::UserLink

  belongs_to :negative_user_node_from_id, :class_name => Node::UserNode, :foreign_key => :node_from_id
  belongs_to :negative_user_node_to_id, :class_name => Node::UserNode, :foreign_key => :node_to_id, :counter_cache => :upvotes_count
  belongs_to :negative_global_node_from_id, :class_name => Node::GlobalNode, :foreign_key => :global_node_from_id
  belongs_to :negative_global_node_to_id, :class_name => Node::GlobalNode, :foreign_key => :global_node_to_id, :counter_cache => :upvotes_count

end
