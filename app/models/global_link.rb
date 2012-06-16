class GlobalLink < ActiveRecord::Base
  belongs_to :node_from, :class_name => "Node", :foreign_key=>'node_from_id'
  belongs_to :node_to, :class_name => "Node", :foreign_key=>'node_to_id'
  belongs_to :global
  belongs_to :link
  has_many :global_link_users
  belongs_to :global_node_to, :class_name => "GlobalNode", :foreign_key=>'global_node_to_id', :counter_cache => :global_link_users_count
  belongs_to :global_node_from, :class_name => "GlobalNode", :foreign_key=>'global_node_from_id', :counter_cache => :global_link_users_count
  belongs_to :global_node_to, :class_name => "GlobalNode", :foreign_key=>'global_node_to_id', :counter_cache => :global_link_users_count
  belongs_to :node_from, :class_name => "Node", :foreign_key=>'node_from_id', :counter_cache => :global_link_users_count

  validates_uniqueness_of :link_id, :scope => [:global_id]
  validates_uniqueness_of :global_id, :scope => [:value, :node_from_id, :node_to_id]
end
