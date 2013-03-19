require "#{Rails.root}/lib/validators.rb"
class Link::UserLink < Link
  belongs_to :global_link, :counter_cache => :users_count
  belongs_to :user
  belongs_to :global_node_from, :foreign_key => :global_node_from_id, :class_name => Node::GlobalNode
  belongs_to :global_node_to, :foreign_key => :global_node_to_id, :class_name => Node::GlobalNode

  validates :user_id, :uniqueness => {:scope => [:global_link_id]}

  include Validators
  validate :correct_context_attributes
  def correct_context_attributes(context_attributes = [:group_id]);super;end
  validates :user_id, :presence => true

  has_many :user_groups, :foreign_key => :user_id, :primary_key => :user_id
  has_many :group_links, :through => :user_groups
  
  after_save :update_group_link_users_count
  after_destroy :update_group_link_users_count

  def update_group_link_users_count
    self.group_links.reload.each do |gl|
      gl.update_users_count
    end
  end

end
