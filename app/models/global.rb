class Global < ActiveRecord::Base
  has_many :globals_nodes, :class_name=>'GlobalsNodes'
  has_many :nodes, :through => :globals_nodes
  has_many :globals_users
  has_many :users, :through => :globals_users
end
