class Node < ActiveRecord::Base
  validates :title, :presence => true
  has_many :links
  has_many :target_nodes, :through => :links, :class_name => "Node", :foreign_key => "node_from"
  has_many :source_nodes, :through => :links, :class_name => "Node", :foreign_key => "node_to"
  #has_many :related_nodes, :through => :links
  
end
