class LinkUser < ActiveRecord::Base
  belongs_to :link
  belongs_to :user
  has_many :global_link_users

  validates_uniqueness_of :link_id, :scope => [:user_id]
  validates_uniqueness_of :value, :scope => [:node_from_id, :node_to_id]
end
