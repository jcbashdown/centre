require "#{Rails.root}/lib/link_creation_module.rb"

class ContextLink < ActiveRecord::Base
  include LinkCreationModule
  belongs_to :question
  belongs_to :user
  belongs_to :global_link, :class_name => Link::GlobalLink
  belongs_to :question_link, :class_name => Link::QuestionLink
  belongs_to :user_link, :class_name => Link::UserLink
  belongs_to :global_node_from, :class_name => Node::GlobalNode
  belongs_to :global_node_to, :class_name => Node::GlobalNode
  belongs_to :question_node_from, :class_name => Node::QuestionNode
  belongs_to :question_node_to, :class_name => Node::QuestionNode
  belongs_to :user_node_from, :class_name => Node::UserNode
  belongs_to :user_node_to, :class_name => Node::UserNode
  belongs_to :context_node_from, :class_name => ContextNode
  belongs_to :context_node_to, :class_name => ContextNode

end
