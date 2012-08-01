require "#{Rails.root}/lib/link_creation_module.rb"
require "#{Rails.root}/lib/link_deletion_module.rb"
require "#{Rails.root}/lib/link_update_module.rb"
require "#{Rails.root}/lib/activerecord_import_methods.rb"

class ContextLink < ActiveRecord::Base
  include ActiverecordImportMethods
  include LinkCreationModule
  include LinkDeletionModule
  include LinkUpdateModule
  belongs_to :question
  belongs_to :user
  belongs_to :global_link, :class_name => Link::GlobalLink
  belongs_to :question_link, :class_name => Link::QuestionLink, :counter_cache => :users_count
  belongs_to :user_link, :class_name => Link::UserLink
  belongs_to :global_node_from, :class_name => Node::GlobalNode
  belongs_to :global_node_to, :class_name => Node::GlobalNode
  belongs_to :question_node_from, :class_name => Node::QuestionNode
  belongs_to :question_node_to, :class_name => Node::QuestionNode
  belongs_to :user_node_from, :class_name => Node::UserNode
  belongs_to :user_node_to, :class_name => Node::UserNode
  belongs_to :context_node_from, :class_name => ContextNode
  belongs_to :context_node_to, :class_name => ContextNode

  validates_uniqueness_of :user_id, :scope => [:global_link_id, :question_id]

  before_validation(:on => :create) do
    create_appropriate_nodes
    create_appropriate_links
  end

  after_destroy :delete_appropriate_links

  #before_update :update_sublinks
  #after_update :update_appropriate_links
  #attr_accessor :new_type, :no_other_context_links
  #need in accessible as well for mass assign

  def update_type(type)
    ContextLink.where('user_link_id = ? AND id != ?', self.user_link_id, self.id).each do |cl|
      attributes = {:user => cl.user, :question => cl.question, :global_node_from_id => cl.global_node_from_id, :global_node_to_id => cl.global_node_to_id}
      cl.destroy
      "ContextLink::#{type}ContextLink".constantize.create!(attributes)
    end
    attributes = {:user => self.user, :question => self.question, :global_node_from_id => self.global_node_from_id, :global_node_to_id => self.global_node_to_id}
    self.destroy
    "ContextLink::#{type}ContextLink".constantize.create(attributes)
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
