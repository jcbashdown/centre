class Node::UserNode < Node
  belongs_to :global_node

  searchable do
    text :title
    integer :id
    integer :user_id
  end
  
  def set_caches_and_conclusion
    self.users_count = ContextNode.count( :conditions => ["#{self.type.gsub("Node::", "").underscore}_id = ?", self.id] )
  end
end
