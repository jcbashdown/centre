class Link::QuestionLink < Link
  belongs_to :question_node_from, :foreign_key => :node_from_id, :class_name => Node::QuestionNode
  belongs_to :question_node_to, :foreign_key => :node_to_id, :class_name => Node::QuestionNode
end
