class Link::GroupLink < Link
  belongs_to :group_node_from, :foreign_key => :node_from_id, :class_name => Node::GroupNode
  belongs_to :group_node_to, :foreign_key => :node_to_id, :class_name => Node::GroupNode
  belongs_to :global_link

  class << self
    def update_active(gn_from, gn_to, group)
      unless (current_active = active(gn_from, gn_to, group)) == (by_votes = active_by_votes(gn_from, gn_to, group))
        current_active.update_attributes(:active => false) if current_active
        by_votes.update_attributes(:active => true)
      end
    end
  
    def active_by_votes(gn_from, gn_to, group)
      where(:global_node_from_id => gn_from, :global_node_to_id => gn_to, :group_id => group).order(:users_count).last
    end
    def active(gn_from, gn_to, group)
      where(:global_node_from_id => gn_from, :global_node_to_id => gn_to, :active => true, :group_id => group).last
    end
  end
end

class Link::GroupLink::EquivalentGroupLink < Link::GroupLink;end
class Link::GroupLink::NegativeGroupLink < Link::GroupLink;
  belongs_to :negative_group_node_from, :class_name => Node::GroupNode, :foreign_key => :node_from_id
  belongs_to :negative_group_node_to, :class_name => Node::GroupNode, :foreign_key => :node_to_id, :counter_cache => :downvotes_count
end
class Link::GroupLink::PartOfGroupLink < Link::GroupLink;end
class Link::GroupLink::PositiveGroupLink < Link::GroupLink;end
class Link::GroupLink::RelatedGroupLink < Link::GroupLink;end
