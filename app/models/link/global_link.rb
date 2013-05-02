require "#{Rails.root}/lib/validators.rb"
class Link::GlobalLink < Link
  default_scope where(:active => true)

  belongs_to :global_node_from, :foreign_key => :global_node_from_id, :class_name => Node::GlobalNode
  belongs_to :global_node_to, :foreign_key => :global_node_to_id, :class_name => Node::GlobalNode
  has_many :user_links

  include Validators
  validate :correct_context_attributes
  def correct_context_attributes(context_attributes = [:user_id, :group_id]);super;end
  after_create :initialize_users_count

  def global_link
    self
  end

  def initialize_users_count
    self.update_attribute(:users_count, self.user_links.reload.count)
    ensure_correct_active
  end

  def update_users_count
    if (users_count = self.reload.user_links.count) > 0
      self.update_attribute(:users_count, users_count)
    else
      self.destroy if self.persisted?
    end
    ensure_correct_active
  end

end

class Link::GlobalLink::NegativeGlobalLink < Link::GlobalLink;end
class Link::GlobalLink::PositiveGlobalLink < Link::GlobalLink;end
class Link::GlobalLink::NoLinkGlobalLink < Link::GlobalLink;end
