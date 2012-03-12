class Global < ActiveRecord::Base
  has_many :nodes_globals
  has_many :nodes, :through=>:nodes_globals
  has_many :globals_links
  has_many :links, :through=>:globals_links
  has_many :globals_users
  has_many :users, :through=>:globals_users

  validates :name, :presence => true
end
