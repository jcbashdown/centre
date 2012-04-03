class GlobalNodeUser < ActiveRecord::Base
  belongs_to :global
  belongs_to :node
  belongs_to :user
  belongs_to :node_user, :counter_cache => true
  belongs_to :global_node, :counter_cache => true

  after_save :update_xml, :update_globals_user_xml
  after_create :set_or_create_node, :set_or_create_global_node, :set_or_create_node_user
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
    if global_node.global_node_users_count < 2
      global_node.destroy
    end
  end

  def delete_node_user_if_allowed
    if node_user.global_node_users_count < 2
      node_user.destroy
    end
  end

  def delete_node_if_allowed

  end

  def update_xml

  end

  def update_globals_user_xml

  end
end
