require "#{Rails.root}/lib/node_creation_module.rb"
require "#{Rails.root}/lib/node_deletion_module.rb"
require "#{Rails.root}/lib/activerecord_import_methods.rb"

class ContextNode < ActiveRecord::Base
  searchable do
    text :title
    integer :id
    integer :global_node_id
    integer :question_id
    integer :user_id
    boolean :is_conclusion
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

  validates :title, :uniqueness => {:scope => [:question_id, :user_id]}

  before_validation(:on => :create) do
    create_appropriate_nodes
  end

  after_save :update_caches, :update_conclusions
  after_destroy :delete_appropriate_nodes, :update_caches, :update_conclusions

  def update_caches
    self.global_node.save! if self.global_node.try(:persisted?)
  end

  def update_conclusions
    [QuestionConclusion, GroupQuestionConclusion, UserQuestionConclusion].each do |conclusion_class|
      conclusion_class.update_conclusion_status_for(context)
    end
  end

  def context
    HashWithIndifferentAccess.new({:question_id => self.question_id, :group_ids => self.user.groups.map(&:id), :user_id => self.user_id, :global_node_id => self.global_node_id})
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
    
    def find_by_context conditions
      #.results could be .hits if don't need to get from db (just get from solr index)
      results = search do
        fulltext conditions[:query] if conditions[:query]
        with :global_node_id, conditions[:global_node_id] if conditions[:global_node_id]
        with :question_id, conditions[:question] if conditions[:question]
        with :user_id, conditions[:user] if conditions[:user]
        with(:user_id).any_of conditions[:user_ids] if conditions[:user_ids].try(:any?)#proxy for group
        with :is_conclusion, conditions[:is_conclusion] if conditions[:is_conclusion]
        order_by(:id, :asc)
      end.results
    end
    
  end
end
