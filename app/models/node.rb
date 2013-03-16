class Node < ActiveRecord::Base
  before_save :set_caches_and_conclusion

  def set_caches_and_conclusion
    self.users_count = ContextNode.count( :conditions => ["#{self.type.gsub("Node::", "").underscore}_id = ?", self.id] )
  end

end

