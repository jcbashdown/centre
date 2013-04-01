require "#{Rails.root}/lib/validators.rb"
require "#{Rails.root}/lib/link_creation_module.rb"
require "#{Rails.root}/lib/link_deletion_module.rb"

class Link::UserLink < Link
  include LinkCreationModule
  include LinkDeletionModule
  attr_accessor :question_id 
  attr_accessor :question
  attr_accessor :context_node_from_title

  belongs_to :global_link, :counter_cache => :users_count
  belongs_to :user
  belongs_to :global_node_from, :foreign_key => :global_node_from_id, :class_name => Node::GlobalNode
  belongs_to :global_node_to, :foreign_key => :global_node_to_id, :class_name => Node::GlobalNode
  has_many :user_groups, :foreign_key => :user_id, :primary_key => :user_id
  has_many :group_links, :through => :user_groups

  validates :user_id, :uniqueness => {:scope => [:global_link_id]}
  include Validators
  validate :correct_context_attributes
  def correct_context_attributes(context_attributes = [:group_id]);super;end
  validates :user_id, :presence => true

  class << self
    [:create, :create!].each do |method|
      define_method method do |attributes = {}|
        attributes = new(attributes).create_appropriate_nodes.creation_attributes
        super(attributes)
      end
    end
  end

  def creation_attributes
    attributes.merge({:question_id => question_id})
  end

  before_validation(:on => :create) do
    #if validation will return true
    # end
    # then actual validation will happen whatever
    create_appropriate_links
    # ---
    # use different method
    # use non db context_link?
    # other callback so no rollback?
  end
  
  after_save :update_group_link_users_count, :update_active_links
  after_destroy :update_group_link_users_count, :delete_appropriate_links, :update_active_links

  def link_kind
    self.type.gsub(/Link::UserLink::|UserLink/, "")
  end

  def update_type(new_type, question=nil)
    destroy
    self.user
    "Link::UserLink::#{new_type}UserLink".constantize.create!({ 
      :user_id =>self.user_id, 
      :question => question, 
      :global_node_to_id => self.global_node_to_id, 
      :global_node_from_id =>self.global_node_from_id 
    })
  end

  def update_group_link_users_count
    self.group_links.reload.each do |gl|
      gl.update_users_count
    end
  end

  def question
    @question ||= Question.find_by_id question_id
  end

  def question_id
    @question_id ||= @question.id
  end

  def user_link
    self
  end

  def user_link_id
    self.id
  end

  protected

  def update_active_links
    Link::GlobalLink.update_active(self.global_node_from_id, self.global_node_to_id)
  end

end
