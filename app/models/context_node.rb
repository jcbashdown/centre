require "#{Rails.root}/lib/node_creation_module.rb"

class ContextNode < ActiveRecord::Base
  #no nested attributes as belongs to
  include NodeCreationModule
  belongs_to :node_title#for title creation through nested attributes
  belongs_to :global_node, :class_name => Node::GlobalNode, :counter_cache => :users_count#for user counts and conclusions
  belongs_to :user_node, :class_name => Node::UserNode, :counter_cache => :users_count#for user counts and conclusions
  belongs_to :question_node, :class_name => Node::QuestionNode, :counter_cache => :users_count#for user counts and conclusions
  belongs_to :user
  belongs_to :question

  validates_presence_of :title
  validates_presence_of :global_node
  validates_presence_of :user_node
  validates_presence_of :user

  validates :node_title_id, :uniqueness => {:scope => [:question_id, :user_id]}

  before_validation(:on => :create) do
    create_appropriate_nodes
  end

  def question?
    question_id.present?
  end

  class << self
    def with_all_associations
      context_node.includes(:node_title, :global_node, :question_node, :user_node)
    end
  end
end
