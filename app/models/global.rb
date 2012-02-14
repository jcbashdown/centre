class Global < ActiveRecord::Base
  has_many :nodes_globals
  has_many :nodes, :through=>:nodes_globals
  has_and_belongs_to_many :links
  has_and_belongs_to_many :users

  validates :name, :presence => true
end
