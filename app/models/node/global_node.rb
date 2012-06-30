class Node::GlobalNode < Node
  searchable do
    text :title
    integer :id
    double :page_rank
    time :created_at
  end
  belongs_to :node_title

  validates :title, :presence => true
  validates_uniqueness_of :title
  validates_uniqueness_of :title_id

end
