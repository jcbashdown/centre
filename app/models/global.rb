class Global < ActiveRecord::Base
  has_many :global_nodes, :class_name=>'GlobalNode'
  has_many :nodes, :through => :global_nodes
  has_many :global_users
  has_many :users, :through => :global_users
  has_many :global_links
  has_many :links, :through => :global_links
  has_many :global_link_users
  has_many :global_node_users
end
