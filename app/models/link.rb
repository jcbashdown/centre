class Link < ActiveRecord::Base

  class << self

    def opposite_direction(direction)
      {"to" => "from", "from" => "to"}[direction]
    end
 
  end

end
