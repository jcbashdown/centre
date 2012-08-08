class Node::GlobalNode < Node
  searchable do
    text :title
    integer :id
    double :page_rank
    time :created_at
  end

  validates :title, :presence => true
  validates_uniqueness_of :title

end
