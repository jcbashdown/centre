require "node_creation_module"
require "node_deletion_module"

class Node::UserNode < Node
  set_table_name 'user_nodes'
  include NodeCreationModule
  include NodeDeletionModule
  attr_accessor :question_id 
  attr_accessor :question

  belongs_to :global_node, :class_name => Node::GlobalNode
  belongs_to :user

  validates_presence_of :global_node
  validates_presence_of :user

  after_save :update_caches
  after_destroy :update_caches, :delete_appropriate_nodes

  def question
    @question ||= Question.find_by_id question_id
  end

  def question_id
    @question_id ||= @question.try(:id)
  end

  class << self
    [:create, :create!].each do |method|
      define_method method do |attributes = {}|
        new_user_node = self.new(attributes)
        ActiveRecord::Base.transaction do
          new_user_node.create_appropriate_nodes
          new_user_node.save if method == :create
          new_user_node.save! if method == :create!
        end
        new_user_node.create_context_node_if_needed
	new_user_node
      end
    end
  end

  def create_context_node_if_needed
    context_node = ContextNode.where(context)[0] || ContextNode.create!(context)
  end

  def context
    HashWithIndifferentAccess.new({:question_id => self.question_id, :user_id => self.user_id, :title=> self.title, :user_node_id => self.id, :is_conclusion => self.is_conclusion})
  end

  def update_caches
    self.global_node.save! if self.global_node.try(:persisted?)
  end
end
