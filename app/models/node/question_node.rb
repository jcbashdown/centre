class Node::QuestionNode < Node

  searchable do
    text :title
    integer :id
    integer :question_id
  end
end
