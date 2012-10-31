class Node::GlobalNode < Node
  searchable do
    text :title
    integer :id
  end
  def global_node
    self
  end

  validates :title, :presence => true
  validates_uniqueness_of :title

end
