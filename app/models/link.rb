class Link < ActiveRecord::Base
  belongs_to :node_from, :class_name => "Node", :foreign_key=>'node_from_id'
  belongs_to :node_to, :class_name => "Node", :foreign_key=>'node_to_id'
  
  has_many :link_users
  has_many :users, :through => :link_users
  #validates :node_from, :presence => true
  #validates :node_to, :presence => true
  validates_uniqueness_of :value, :scope => [:node_from_id, :node_to_id]
end
