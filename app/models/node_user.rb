class NodeUser < ActiveRecord::Base
  belongs_to :node
  belongs_to :user
  has_many :global_node_users

  validates :node, :presence => true

  validates_uniqueness_of :node_id, :scope => [:user_id]
end
