class Link::UserLink::NegativeUserLink < Link::UserLink

  belongs_to :negative_user_node_from, :class_name => Node::UserNode, :foreign_key => :node_from_id
  belongs_to :negative_user_node_to, :class_name => Node::UserNode, :foreign_key => :node_to_id, :counter_cache => :downvotes_count
  belongs_to :negative_global_node_from, :class_name => Node::GlobalNode, :foreign_key => :global_node_from_id
  belongs_to :negative_global_node_to, :class_name => Node::GlobalNode, :foreign_key => :global_node_to_id, :counter_cache => :downvotes_count

end