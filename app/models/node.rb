class Node < ActiveRecord::Base
  validates :title, :presence => true
  has_many :links_in, :foreign_key => "node_to", :class_name => "Link"
  has_many :links_to, :foreign_key => "node_from", :class_name => "Link"
  has_many :target_nodes, :through => :links_to, :class_name => "Node", :foreign_key => "node_from"
  has_many :source_nodes, :through => :links_in, :class_name => "Node", :foreign_key => "node_to"
  #has_many :related_nodes, :through => :links
  
end
