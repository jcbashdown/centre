class Link < ActiveRecord::Base

  class << self

    def opposite_direction(direction)
      HashWithIndifferentAccess.new({"to" => "from", "from" => "to"})[direction]
    end

    def active
      order("users_count desc").limit(1)[0]
    end

    def active_for params
      where(params).active
    end
    
    def positive
      where("type LIKE '%Positive%'")
    end

    def negative
      where("type LIKE '%Negative%'")
    end

    [:user_link, :global_link, :group_link].each do |link_type|
      define_method link_type do
        "Link::#{link_type.to_s.classify}".constantize
      end
    end
  end

  def ensure_correct_active
    active_by_votes = self.class.active_for(self.global_node_attrs)
    current_active = self.class.where({active:true}.merge(self.global_node_attrs)).limit(1)[0]
    unless active_by_votes == current_active
      active_by_votes.update_attribute(:active, true)
      current_active.update_attribute(:active, false)
    end
  end

  def positive?
    self.type.to_s =~ /Positive/
  end
  def negative?
    self.type.to_s =~ /Negative/
  end

  def global_node_attrs
    {global_node_to_id: self.global_node_to_id, global_node_from_id: self.global_node_from_id}
  end
end
