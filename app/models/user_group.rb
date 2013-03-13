class UserGroup < ActiveRecord::Base
  attr_accessible :group_id, :user_id

  belongs_to :user
  belongs_to :group

  has_many :group_links, :foreign_key => :group_id, :primary_key => :group_id
  has_many :user_links, :foreign_key => :user_id, :primary_key => :user_id

  #when user joins group, update group conclusions and user_counts/activation
#  after_save :update_link_counts
#
#  def update_link_counts
#    self.group_links.each do |gl|
#      p gl
#    end
#  end
end
