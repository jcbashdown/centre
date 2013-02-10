require "#{Rails.root}/lib/node_creation_module.rb"
require "#{Rails.root}/lib/node_deletion_module.rb"
require "#{Rails.root}/lib/activerecord_import_methods.rb"

class ContextNode < ActiveRecord::Base
  searchable do
    text :title
    integer :id
    integer :question_id
    integer :group_id
    integer :user_id
  end
  include ActiverecordImportMethods
  include NodeDeletionModule
  include NodeCreationModule
  belongs_to :node_title
  belongs_to :global_node, :class_name => Node::GlobalNode
  belongs_to :user
  belongs_to :question
  belongs_to :group

  has_many :positive_link_froms, :foreign_key => "context_node_to_id", :class_name => "ContextLink::PositiveContextLink"
  has_many :positive_link_tos, :foreign_key => "context_node_from_id", :class_name => "ContextLink::PositiveContextLink"
  has_many :negative_link_froms, :foreign_key => "context_node_to_id", :class_name => "ContextLink::NegativeContextLink"
  has_many :negative_link_tos, :foreign_key => "context_node_from_id", :class_name => "ContextLink::NegativeContextLink"

  has_many :positive_node_tos, :through => :positive_link_tos, :class_name => "ContextNode", :foreign_key => "context_node_to_id", :source=>:context_node_to
  has_many :positive_node_froms, :through => :positive_link_froms, :class_name => "ContextNode", :foreign_key => "context_node_from_id", :source=>:context_node_from
  has_many :negative_node_tos, :through => :negative_link_tos, :class_name => "ContextNode", :foreign_key => "context_node_to_id", :source=>:context_node_to
  has_many :negative_node_froms, :through => :negative_link_froms, :class_name => "ContextNode", :foreign_key => "context_node_from_id", :source=>:context_node_from

  validates_presence_of :title
  validates_presence_of :global_node
  validates_presence_of :user

  validates :title, :uniqueness => {:scope => [:group_id, :question_id, :user_id]}

  before_validation(:on => :create) do
    create_appropriate_nodes
  end

  after_save :update_caches
  after_destroy :delete_appropriate_nodes, :update_caches

  def update_caches
    if (gn = Node::GlobalNode.find_by_id(self.global_node_id))
      gn.save!
    end
  end

  def set_conclusion! value
    update_attributes(:is_conclusion => value)
  end 

  def question?
    question_id.present?
  end

  class << self
    def with_all_associations
      ContextNode.includes(:node_title, :global_node)
    end
  end
end
