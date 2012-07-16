require "#{Rails.root}/lib/link_creation_module.rb"
require "#{Rails.root}/lib/link_deletion_module.rb"
require "#{Rails.root}/lib/activerecord_import_methods.rb"

class ContextLink < ActiveRecord::Base
  include ActiverecordImportMethods
  include LinkCreationModule
  include LinkDeletionModule
  belongs_to :question
  belongs_to :user
  belongs_to :global_link, :class_name => Link::GlobalLink, :counter_cache => :users_count
  belongs_to :question_link, :class_name => Link::QuestionLink, :counter_cache => :users_count
  belongs_to :user_link, :class_name => Link::UserLink, :counter_cache => :users_count
  belongs_to :global_node_from, :class_name => Node::GlobalNode
  belongs_to :global_node_to, :class_name => Node::GlobalNode
  belongs_to :question_node_from, :class_name => Node::QuestionNode
  belongs_to :question_node_to, :class_name => Node::QuestionNode
  belongs_to :user_node_from, :class_name => Node::UserNode
  belongs_to :user_node_to, :class_name => Node::UserNode
  belongs_to :context_node_from, :class_name => ContextNode, :counter_cache => :context_links_count
  belongs_to :context_node_to, :class_name => ContextNode, :counter_cache => :context_links_count

  before_validation(:on => :create) do
    create_appropriate_nodes
    create_appropriate_links
  end

  def link_kind
    self.type.gsub(/ContextLink::|ContextLink/, "")
  end

  class << self
    def with_all_associations
      ContextLink.includes(:question, :user, :global_node_from, :global_node_to, :question_node_from, :question_node_to, :user_node_from, :user_node_to, :context_node_from, :context_node_to, :user_link, :global_link, :question_link)
    end
  end
end
