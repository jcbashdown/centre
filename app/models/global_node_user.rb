class GlobalNodeUser < ActiveRecord::Base
  belongs_to :global
  belongs_to :node
  belongs_to :user
  belongs_to :node_user, :counter_cache => true
  belongs_to :global_node, :counter_cache => true

  before_save :update_xml, :update_globals_user_xml
  after_create :create_global_node, :create_node_user, :set_all
  after_destroy :update_xml, :delete_global_node, :delete_node_user, :delete_all

  validates_uniqueness_of :node_id, :scope => [:global_id, :user_id]
  
  protected
  def create_global_node
    gn = GlobalNode.where(:global_id => self.global_id, :node_id => self.node_id)[0] || GlobalNode.create(:global_id => self.global_id, :node_id => self.node_id)
    self.global_node = gn
    save
  end

  def create_node_user
    nu = NodeUser.where(:user_id => self.user_id, :node_id => self.node_id)[0] || NodeUser.create(:user_id => self.user_id, :node_id => self.node_id)
    self.node_user = nu
    save
  end

  def set_all
    unless self.global.name == 'All'
      GlobalNodeUser.where(:user_id=>self.user_id, :node_id=>self.node_id, :global_id=>Global.find_by_name('All').id)[0] || GlobalNodeUser.create(:user=>self.user, :node=>self.node, :global=>Global.find_by_name('All'))
    end
  end

  def delete_global_node
    if global_node.global_node_users_count < 2
      global_node.destroy
    end
  end

  def delete_node_user
    if node_user.global_node_users_count < 2
      node_user.destroy
    end
  end

  def delete_all
    unless self.global.name == 'All'
      GlobalNodeUser.where(:user_id=>self.user_id, :node_id=>self.node_id, :global_id=>Global.find_by_name('All').id)[0].destroy
    end
  end

  def update_xml

  end

  def update_globals_user_xml

  end
end
