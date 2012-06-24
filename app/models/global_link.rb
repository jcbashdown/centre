require "#{Rails.root}/lib/global_link_mixin.rb"

class GlobalLink < ActiveRecord::Base
  include LinkMixin
  include GlobalLinkMixin

  belongs_to :link
  has_many :global_link_users

  validates_uniqueness_of :link_id, :scope => [:global_id]
  validates_uniqueness_of :global_id, :scope => [:value, :node_from_id, :node_to_id]
end
