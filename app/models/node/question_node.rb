class Node::QuestionNode < Node
  belongs_to :global_node

  searchable do
    text :title
    integer :id
    integer :question_id
  end
end
