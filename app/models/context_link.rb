require "#{Rails.root}/lib/link_creation_module.rb"
require "#{Rails.root}/lib/link_deletion_module.rb"
require "#{Rails.root}/lib/activerecord_import_methods.rb"

class ContextLink < ActiveRecord::Base
  include ActiverecordImportMethods
  include LinkCreationModule
  include LinkDeletionModule
  belongs_to :question
  belongs_to :group
  belongs_to :user
  belongs_to :global_link, :class_name => Link
  belongs_to :group_link, :class_name => Link::GroupLink
  belongs_to :user_link, :class_name => Link::UserLink
  belongs_to :global_node_from, :class_name => Node::GlobalNode
  belongs_to :global_node_to, :class_name => Node::GlobalNode
  belongs_to :context_node_from, :class_name => ContextNode
  belongs_to :context_node_to, :class_name => ContextNode

  attr_accessor :context_node_from_title

  #dont need question? or includes uniq on nil for question?
  validates_uniqueness_of :user_id, :scope => [:global_link_id, :question_id, :group_id]

  before_validation(:on => :create) do
    #if validation will return true
    create_appropriate_nodes
    create_appropriate_links
    # end
    # then actual validation will happen whatever
  end

  after_destroy :delete_appropriate_links, :update_active_links
  after_create :update_active_links

  def destroy_all_for_user_link
    ContextLink.where('user_link_id = ?', self.user_link_id).each do |cl|
      cl.destroy
    end
  end

  def update_type(type)
    ContextLink.where('user_link_id = ? AND id != ?', self.user_link_id, self.id).each do |cl|
      attributes = {:user => cl.user, :question => cl.question, :group => cl.group, :global_node_from_id => cl.global_node_from_id, :global_node_to_id => cl.global_node_to_id}
      cl.destroy
      "ContextLink::#{type}ContextLink".constantize.create!(attributes)
    end
    attributes = {:user => self.user, :question => self.question, :group => self.group, :global_node_from_id => self.global_node_from_id, :global_node_to_id => self.global_node_to_id}
    self.destroy
    "ContextLink::#{type}ContextLink".constantize.create(attributes)
  end

  def link_kind
    self.type.gsub(/ContextLink::|ContextLink/, "")
  end

  class << self
    def with_all_associations
      ContextLink.includes(:question, :user, :global_node_from, :global_node_to, :context_node_from, :context_node_to, :user_link, :global_link, :group_link)
    end
  end

  protected

  def update_active_links
    Link::GlobalLink.update_active(self.global_node_from_id, self.global_node_to_id)
  end
end
