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
  has_many :context_nodes

  validates_presence_of :global_node
  validates_presence_of :user
  validates :user_id, :uniqueness => {:scope => [:title]}

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
        attributes = HashWithIndifferentAccess.new(attributes)
        question_id = attributes[:question_id] ? attributes[:question_id] : attributes[:question].try(:id)
        user_id = attributes[:user_id] ? attributes[:user_id] : attributes[:user].id
        unless new_user_node = self.where(attributes.except(:user,:question,:question_id,:is_conclusion).merge(user_id:user_id))[0]
          new_user_node = self.new(attributes)
          ActiveRecord::Base.transaction do
            new_user_node.create_appropriate_nodes
            new_user_node.save if method == :create
            new_user_node.save! if method == :create!
          end
        end
        new_user_node.question_id = question_id
        new_user_node.user_id = user_id
        new_user_node.is_conclusion = attributes[:is_conclusion]
        new_user_node.create_context_node_if_needed
        new_user_node
      end
    end
  end

  def update_title new_title
    old_global_node_id = self.global_node_id
    old_global_node = self.global_node
    old_links = self.user_links
    new_links = old_links.map(&:dup)
    new_global_node_id = Node::GlobalNode.where(:title => new_title)[0].try(:id) || Node::GlobalNode.create!({:title => new_title}).id
    update_attributes(global_node_id: new_global_node_id)
    old_global_node.save
    context_nodes.each do |cn|
      cn.save
    end
    ActiveRecord::Base.transaction do
      old_links.destroy_all#probably already done at this point
      new_links.each do |link|
        link.global_node_from_id = new_global_node_id if link.global_node_from_id == old_global_node_id
        link.global_node_to_id = new_global_node_id if link.global_node_to_id == old_global_node_id
        link.type.constantize.create(link.attributes.merge(:no_nodes => true))
      end
    end
    self
  end

  def in_link_sql
    "global_node_from_id = ? || global_node_to_id = ?"
  end

  def user_links
    Link::UserLink
      .where(:user_id => self.user_id)
      .where(in_link_sql, self.global_node_id, self.global_node_id)
  end

  def group_links
    self.user.groups.inject([]) do |links, group| 
      links+= group.group_links
        .where(in_link_sql, self.global_node_id, self.global_node_id)
        .where(:global_link_id => self.user_links.map(&:global_link_id))
      links
    end
  end

  def global_links
    Link::GlobalLink
      .where(in_link_sql, self.global_node_id, self.global_node_id)
      .where(:global_link_id => self.user_links.map(&:global_link_id))
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
