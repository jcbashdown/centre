class ContextLink::NegativeContextLink < ContextLink
 belongs_to :downvoted_question_node_to, :foreign_key => :question_node_to_id, :counter_cache => :downvotes_count, :class_name => Node::QuestionNode
end
