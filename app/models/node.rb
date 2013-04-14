class Node < ActiveRecord::Base
  before_save :set_caches

  def set_caches
    self.users_count = ContextNode.count( :conditions => ["#{self.type.gsub("Node::", "").underscore}_id = ?", self.id] )
  end

end

