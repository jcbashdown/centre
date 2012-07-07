class Node < ActiveRecord::Base
  before_save :set_caches_and_conclusion
  def set_caches_and_conclusion
    self.users_count = ContextNode.count( :conditions => ["#{self.type.gsub("Node::", "").underscore}_id = ?", self.id] )
    self.conclusion_votes_count = ContextNode.count( :conditions => ["is_conclusion = true AND #{self.type.gsub("Node::", "").underscore}_id = ?", self.id] )
    if self.conclusion_votes_count > (self.users_count/2)
      self.is_conclusion = true
    else
      self.is_conclusion = false
    end
    nil
  end
end

