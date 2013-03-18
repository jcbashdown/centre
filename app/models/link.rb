class Link < ActiveRecord::Base

  class << self

    def opposite_direction(direction)
      HashWithIndifferentAccess.new({"to" => "from", "from" => "to"})[direction]
    end
    
    def positive
      where("type LIKE '%Positive%'")
    end

    def negative
      where("type LIKE '%Negative%'")
    end
  end

end
