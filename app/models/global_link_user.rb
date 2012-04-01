class GlobalLinkUser < ActiveRecord::Base
  belongs_to :node_from, :class_name => "Node", :foreign_key=>'node_from_id'
  belongs_to :node_to, :class_name => "Node", :foreign_key=>'node_to_id'
  #make this work for this rel or use else
  belongs_to :global_node_user_from, :class_name => "GlobalNodeUser", :foreign_key=>'node_from_id'
  belongs_to :global_node_user_to, :class_name => "GlobalNodeUser", :foreign_key=>'node_to_id'

  belongs_to :global
  belongs_to :link
  belongs_to :user
  belongs_to :link_user, :counter_cache => true
  belongs_to :global_link, :counter_cache => true

  #validates :node_from, :presence => true
  #validates :node_to, :presence => true
  after_create :create_global_link, :create_link_user, :create_global_node_users, :set_all
  after_destroy :delete_global_link, :delete_link_user, :delete_all

  validates_uniqueness_of :link_id, :scope => [:global_id, :user_id]
  
  protected
  def create_global_link
    gl = GlobalLink.where(:global_id => self.global_id, :link_id => self.link_id)[0] || GlobalLink.create(:global_id => self.global_id, :link_id => self.link_id)
    self.global_link = gl
    save
  end

  def create_link_user
    lu = LinkUser.where(:user_id => self.user_id, :link_id => self.link_id)[0] || LinkUser.create(:user_id => self.user_id, :link_id => self.link_id)
    self.link_user = lu
    save
  end
  
  def create_global_node_users

  end

  def set_all
    unless self.global.name == 'All'
      GlobalLinkUser.where(:user_id=>self.user_id, :link_id=>self.link_id, :global_id=>Global.find_by_name('All').id)[0] || GlobalLinkUser.create(:user=>self.user, :link=>self.link, :global=>Global.find_by_name('All'))
    end
  end

  def delete_global_link
    if global_link.global_link_users_count < 2
      global_link.destroy
    end
  end

  def delete_link_user
    if link_user.global_link_users_count < 2
      link_user.destroy
    end
  end

  def delete_all
    unless self.global.name == 'All'
      GlobalLinkUser.where(:user_id=>self.user_id, :link_id=>self.link_id, :global_id=>Global.find_by_name('All').id)[0].destroy
    end
  end

end
