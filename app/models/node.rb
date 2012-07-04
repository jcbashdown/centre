class Node < ActiveRecord::Base
  before_save :set_is_conclusion
  before_destroy :set_is_conclusion
  def set_is_conclusion
    if (users_count - conclusion_votes_count) > (users_count/2)
      is_conclusion = true
    end
  end
end

