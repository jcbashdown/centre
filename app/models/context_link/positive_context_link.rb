class ContextLink::PositiveContextLink < ContextLink
 belongs_to :upvoted_user_node_to, :foreign_key => :user_node_to_id, :counter_cache => :upvotes_count, :class_name => Node::UserNode
 belongs_to :upvoted_question_node_to, :foreign_key => :question_node_to_id, :counter_cache => :upvotes_count, :class_name => Node::QuestionNode
 belongs_to :upvoted_global_node_to, :foreign_key => :global_node_to_id, :counter_cache => :upvotes_count, :class_name => Node::GlobalNode
end
