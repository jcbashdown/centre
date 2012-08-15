class Node::UserNode < Node
  belongs_to :global_node

  searchable do
    text :title
    integer :id
    integer :user_id
  end
end
