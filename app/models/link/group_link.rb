class Link::GroupLink < Link
  belongs_to :global_link
  belongs_to :group
  has_many :user_groups, :foreign_key => :group_id, :primary_key => :group_id
  has_many :user_links, :through => :user_groups

  #validates :group_id, :uniqueness => {:scope => [:global_link_id]}

  after_save :update_active_for_group_link
  after_create :update_users_count

  def update_users_count
    self.update_attribute(:users_count, self.user_links.count)
  end

  def update_active_for_group_link
    self.class.update_active(self.global_node_from_id, self.global_node_to_id, self.group_id)
  end

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
class Link::GroupLink::NegativeGroupLink < Link::GroupLink;end
class Link::GroupLink::PartOfGroupLink < Link::GroupLink;end
class Link::GroupLink::PositiveGroupLink < Link::GroupLink;end
class Link::GroupLink::RelatedGroupLink < Link::GroupLink;end
