require "#{Rails.root}/lib/link_user_mixin.rb"
require "#{Rails.root}/lib/link_mixin.rb"

class LinkUser < ActiveRecord::Base
  include LinkMixin
  include LinkUserMixin

  has_many :global_link_users

  validates_uniqueness_of :user_id, :scope => [:link_id]
  validates_uniqueness_of :user_id, :scope => [:node_from_id, :node_to_id]
end
