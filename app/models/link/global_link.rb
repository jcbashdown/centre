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
    def update_active(n_from, n_to)
      unless (current_active = active(n_from, n_to)) == (by_votes = active_by_votes(n_from, n_to))
        current_active.update_attributes(:active => false) if current_active
        by_votes.update_attributes(:active => true)
      end
    end

    def active_by_votes(n_from, n_to)
      where(:node_from_id => n_from, :node_to_id => n_to).order(:users_count).last
    end
    def active(n_from, n_to)
      where(:node_from_id => n_from, :node_to_id => n_to, :active => true).last
    end

  end

end
