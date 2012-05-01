class GlobalLink < ActiveRecord::Base
  belongs_to :node_from, :class_name => "Node", :foreign_key=>'node_from_id'
  belongs_to :node_to, :class_name => "Node", :foreign_key=>'node_to_id'
  belongs_to :global
  belongs_to :link
  has_many :global_link_users

  validates_uniqueness_of :link_id, :scope => [:global_id]
  validates_uniqueness_of :global_id, :scope => [:value, :node_from_id, :node_to_id]
end
