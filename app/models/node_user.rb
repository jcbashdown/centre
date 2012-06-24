require "#{Rails.root}/lib/node_user_mixin.rb"

class NodeUser < ActiveRecord::Base
  include NodeUserMixin

  belongs_to :node
  has_many :global_node_users

  validates :node, :presence => true
  validates :title, :presence => true

  validates_uniqueness_of :node_id, :scope => [:user_id]
end
