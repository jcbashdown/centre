class Node::QuestionNode < Node

  searchable do
    text :title
    integer :id
    integer :user_id
  end
end
