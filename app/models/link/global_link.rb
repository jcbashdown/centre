class Link::GlobalLink < Link

  belongs_to :global_node_from_id, :foreign_key => :node_from_id
  belongs_to :global_node_to_id, :foreign_key => :node_to_id
  
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
