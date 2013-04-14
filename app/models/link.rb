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

  def positive?
    self.type.to_s =~ /Positive/
  end
  def negative?
    self.type.to_s =~ /Negative/
  end

end
