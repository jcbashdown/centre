require "#{Rails.root}/lib/validators.rb"
class Link::GroupLink < Link
  belongs_to :global_link
  belongs_to :group
  has_many :user_groups, :foreign_key => :group_id, :primary_key => :group_id
  has_many :user_links, :through => :user_groups, :conditions => proc { ["global_link_id = ?", self.global_link_id] }
  belongs_to :global_node_from, :foreign_key => :global_node_from_id, :class_name => Node::GlobalNode
  belongs_to :global_node_to, :foreign_key => :global_node_to_id, :class_name => Node::GlobalNode

  #validates :group_id, :uniqueness => {:scope => [:global_link_id]}
  include Validators
  validate :correct_context_attributes
  def correct_context_attributes(context_attributes = [:user_id]);super;end
  validates :group_id, :presence => true

  after_create :initialize_users_count

  def initialize_users_count
    self.update_attribute(:users_count, self.user_links.reload.count)
  end

  def update_users_count
    if (users_count = self.user_links.reload.count) > 0
      self.update_attribute(:users_count, users_count)
    else
      self.destroy if self.persisted?
    end
  end

end

class Link::GroupLink::NegativeGroupLink < Link::GroupLink;end
class Link::GroupLink::PositiveGroupLink < Link::GroupLink;end
class Link::GroupLink::NoLinkGroupLink < Link::GroupLink;end
