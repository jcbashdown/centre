require "#{Rails.root}/lib/validators.rb"
class Link::GlobalLink < Link

  belongs_to :global_node_from, :foreign_key => :global_node_from_id, :class_name => Node::GlobalNode
  belongs_to :global_node_to, :foreign_key => :global_node_to_id, :class_name => Node::GlobalNode

  include Validators
  validate :correct_context_attributes
  def correct_context_attributes(context_attributes = [:user_id, :group_id]);super;end


  def global_link
    self
  end

  class << self
    def update_active(n_from, n_to)
      unless (current_active = active(n_from, n_to)) == (by_votes = active_by_votes(n_from, n_to))
        current_active.update_attributes(:active => false) if current_active
        by_votes.update_attributes(:active => true)
      end
    end

    def active_by_votes(n_from, n_to)
      where(:global_node_from_id => n_from, :global_node_to_id => n_to).order(:users_count).last
    end
    def active(n_from, n_to)
      where(:global_node_from_id => n_from, :global_node_to_id => n_to, :active => true).last
    end

  end

end

class Link::GlobalLink::NegativeGlobalLink < Link::GlobalLink;end
class Link::GlobalLink::PositiveGlobalLink < Link::GlobalLink;end
class Link::GlobalLink::NoLinkGlobalLink < Link::GlobalLink;end
