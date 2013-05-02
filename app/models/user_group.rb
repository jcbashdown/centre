class UserGroup < ActiveRecord::Base
  attr_accessible :group_id, :user_id

  belongs_to :user
  belongs_to :group

  has_many :group_links, :foreign_key => :group_id, :primary_key => :group_id, :class_name => Link::GroupLink
  has_many :user_links, :foreign_key => :user_id, :primary_key => :user_id, :class_name => Link::UserLink

#when user joins group, update group conclusions and user_counts/activation
  after_create :create_or_update_group_links
  after_destroy :destroy_or_update_group_links

  def create_or_update_group_links
    self.user_links.each do |ul|
      gls = ul.find_or_create_group_links
      gls.each {|gl| gl.update_users_count}
    end
  end

  def destroy_or_update_group_links
    self.group_links.reload.each do |gl|
      gl.update_users_count
    end
    Link::GroupLink.where('users_count = 0').destroy_all
  end
end
