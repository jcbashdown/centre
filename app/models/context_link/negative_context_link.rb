class ContextLink::NegativeContextLink < ContextLink
 belongs_to :downvoted_user_node_to, :foreign_key => :user_node_to_id, :counter_cache => :downvotes_count, :class_name => Node::UserNode
 belongs_to :downvoted_question_node_to, :foreign_key => :question_node_to_id, :counter_cache => :downvotes_count, :class_name => Node::QuestionNode
 belongs_to :downvoted_global_node_to, :foreign_key => :global_node_to_id, :counter_cache => :downvotes_count, :class_name => Node::GlobalNode
end
