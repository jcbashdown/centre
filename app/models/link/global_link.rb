class Link::GlobalLink < Link

  belongs_to :global_node_from, :foreign_key => :node_from_id, :class_name => Node::GlobalNode
  belongs_to :global_node_to, :foreign_key => :node_to_id, :class_name => Node::GlobalNode

  def positive?
    false
  end
  def equivalent?
    false
  end
  def negative?
    false
  end

  class << self
    def update_active
      unless active == active_by_votes
        active.update_attributes(:active => false) if active
        active_by_votes.update_attributes(:active => true)
      end
    end

    def active_by_votes
      order(:users_count).last
    end
    def active
      where(:active => true).last
    end
  end

end
