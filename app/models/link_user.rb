class LinkUser < ActiveRecord::Base
  belongs_to :link, :counter_cache => :users_count 
  belongs_to :user
  has_many :global_link_users

  validates_uniqueness_of :link_id, :scope => [:user_id]
  validates_uniqueness_of :user_id, :scope => [:value, :node_from_id, :node_to_id]
end
