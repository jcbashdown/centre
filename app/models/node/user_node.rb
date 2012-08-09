class Node::UserNode < Node
  searchable do
    text :title
    integer :id
    integer :user_id
  end
end
