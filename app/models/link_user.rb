class LinkUser < ActiveRecord::Base
  belongs_to :node_from, :class_name => "Node", :foreign_key=>'node_from_id'
  belongs_to :node_to, :class_name => "Node", :foreign_key=>'node_to_id'
  belongs_to :link, :counter_cache => :users_count 
  belongs_to :user
  has_many :global_link_users

  validates_uniqueness_of :user_id, :scope => [:link_id]
  validates_uniqueness_of :user_id, :scope => [:node_from_id, :node_to_id]
end
