require "#{Rails.root}/lib/node_creation_module.rb"

class ContextNode < ActiveRecord::Base
  belongs_to :node_title#for title creation through nested attributes
  belongs_to :global_node, :class_name => Node::GlobalNode, :counter_cache => :users_count#for user counts and conclusions
  belongs_to :user_node, :class_name => Node::UserNode, :counter_cache => :users_count#for user counts and conclusions
  belongs_to :question_node, :class_name => Node::QuestionNode, :counter_cache => :users_count#for user counts and conclusions

  validates_presence_of :title
  validates_presence_of :global_node
  validates_presence_of :question_node
  validates_presence_of :user_node

  before_create :create_appropriate_nodes
  include NodeCreationModule

  class << self
    def with_all_associations
      GlobalLinkUser.includes(:title, :global_node, :question_node, :user_node)
    end
  end
end
