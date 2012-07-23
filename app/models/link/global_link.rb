class Link::GlobalLink < Link

  belongs_to :global_node_from, :foreign_key => :node_from_id, :class_name => Node::GlobalNode
  belongs_to :global_node_to, :foreign_key => :node_to_id, :class_name => Node::GlobalNode
  
  def positive?
    false
  end
  def equivalent?
    false
  end
  def negative?
    false
  end

end
