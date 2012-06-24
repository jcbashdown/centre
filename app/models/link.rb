require "#{Rails.root}/lib/link_mixin.rb"

class Link < ActiveRecord::Base
  include LinkMixin

  has_many :link_users
  has_many :users, :through => :link_users
  has_many :global_link_users

  validates_uniqueness_of :value, :scope => [:node_from_id, :node_to_id]
end
