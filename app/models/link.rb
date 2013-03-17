class Link < ActiveRecord::Base

  class << self

    def opposite_direction(direction)
      HashWithIndifferentAccess.new({"to" => "from", "from" => "to"})[direction]
    end
    
    def positive
      "#{self}::Positive#{self.to_s.demodulize}".constantize
    end

    def negative
      "#{self}::Negative#{self.to_s.demodulize}".constantize
    end
  end

end
