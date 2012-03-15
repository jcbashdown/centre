class Node < ActiveRecord::Base
  has_many :global_nodes, :class_name=>'GlobalNode'
  has_many :globals, :through => :global_nodes
  has_many :global_node_users
end
