class Node < ActiveRecord::Base
  has_many :globals_nodes, :class_name=>'GlobalsNodes'
  has_many :globals, :through => :globals_nodes
end
