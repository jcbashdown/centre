class ContextLink::PositiveContextLink < ContextLink
 belongs_to :upvoted_question_node_to, :foreign_key => :question_node_to_id, :counter_cache => :upvotes_count, :class_name => Node::QuestionNode
end
