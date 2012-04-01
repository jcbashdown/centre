class NodeUser < ActiveRecord::Base
  belongs_to :node
  belongs_to :user
  has_many :global_node_users
end
