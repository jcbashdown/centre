class GlobalNodeUser < ActiveRecord::Base
  belongs_to :global
  belongs_to :node, :counter_cache => true
  belongs_to :user
  belongs_to :node_user, :counter_cache => true
  belongs_to :global_node, :counter_cache => true

  has_many :global_link_user_ins, :foreign_key => "global_node_user_to_id", :class_name => "GlobalLinkUser"
  has_many :global_link_user_tos, :foreign_key => "global_node_user_from_id", :class_name => "GlobalLinkUser"

  has_many :global_node_user_tos, :through => :global_link_user_tos, :class_name => "GlobalNodeUser", :foreign_key => "global_node_user_to_id", :source=>:global_node_user_to
  has_many :global_node_user_froms, :through => :global_link_user_ins, :class_name => "GlobalNodeUser", :foreign_key => "global_node_user_from_id", :source=>:global_node_user_from

  after_save :update_xml, :update_globals_user_xml
  after_create :set_or_create_node, :set_or_create_global_node, :set_or_create_node_user
  before_destroy :delete_links_if_allowed
  after_destroy :update_xml, :delete_node_user_if_allowed, :delete_global_node_if_allowed, :delete_node_if_allowed

  validates_uniqueness_of :node_id, :scope => [:global_id, :user_id]
  validates_uniqueness_of :title, :scope => [:global_id, :user_id]

  def node_hash
    {:title => self.title, :text => self.text}
  end
  
  protected
  def set_or_create_node
    n = Node.where(:title => self.title)[0] || Node.create(node_hash)
    self.node = n
    save
  end

  def set_or_create_global_node
    gn = GlobalNode.where(:global_id => self.global_id, :node_id => self.node_id)[0] || GlobalNode.create({:global_id => self.global_id, :node_id => self.node_id}.merge(node_hash))
    self.global_node = gn
    save
  end

  def set_or_create_node_user
    nu = NodeUser.where(:user_id => self.user_id, :node_id => self.node_id)[0] || NodeUser.create({:user_id => self.user_id, :node_id => self.node_id}.merge(node_hash))
    self.node_user = nu
    save
  end

  def delete_global_node_if_allowed
    if global_node.reload.global_node_users_count < 1
      global_node.destroy
    end
  end

  def delete_node_user_if_allowed
    if node_user.reload.global_node_users_count < 1
      node_user.destroy
    end
  end

  def delete_node_if_allowed
    if node.reload.global_node_users_count < 1 
      node.destroy
    end
  end

  def delete_links_if_allowed
    self.global_link_user_tos.each do |glut|
      glut.destroy
    end
    self.global_link_user_ins.each do |glui|
      gluf.destroy
    end
  end

  def update_xml

  end

  def update_globals_user_xml

  end
end
