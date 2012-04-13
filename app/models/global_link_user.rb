class GlobalLinkUser < ActiveRecord::Base
  belongs_to :node_from, :class_name => "Node", :foreign_key=>'node_from_id'
  belongs_to :node_to, :class_name => "Node", :foreign_key=>'node_to_id'
  belongs_to :global_node_user_from, :class_name => "GlobalNodeUser", :foreign_key=>'global_node_user_from_id', :counter_cache => :global_link_users_count
  belongs_to :global_node_user_to, :class_name => "GlobalNodeUser", :foreign_key=>'global_node_user_to_id', :counter_cache => :global_link_users_count
  belongs_to :global_node_from, :class_name => "GlobalNode", :foreign_key=>'global_node_from_id', :counter_cache => :global_link_users_count
  belongs_to :global_node_to, :class_name => "GlobalNode", :foreign_key=>'global_node_to_id', :counter_cache => :global_link_users_count
  belongs_to :node_user_from, :class_name => "NodeUser", :foreign_key=>'node_user_from_id', :counter_cache => :global_link_users_count
  belongs_to :node_user_to, :class_name => "NodeUser", :foreign_key=>'node_user_to_id', :counter_cache => :global_link_users_count

  belongs_to :global
  belongs_to :link, :counter_cache => true
  belongs_to :user
  belongs_to :link_user, :counter_cache => true
  belongs_to :global_link, :counter_cache => true

  #validates :node_from, :presence => true
  #validates :node_to, :presence => true
  after_save :update_caches
  after_create :set_or_create_link, :set_or_create_global_link, :set_or_create_link_user, :set_or_create_global_node_user_and_node_models#update xml
  after_destroy :delete_link_if_allowed, :delete_global_link_if_allowed, :delete_link_user_if_allowed, :update_caches#update xml

  validates_uniqueness_of :link_id, :scope => [:global_id, :user_id]
  validates_uniqueness_of :user_id, :scope => [:node_from_id, :node_to_id]
  
  protected
  def set_or_create_link
    l = Link.where(:node_from_id => self.node_from_id, :node_to_id => self.node_to_id, :value =>  self.value)[0] || Link.create(:node_from_id => self.node_from_id, :node_to_id => self.node_to_id, :value =>  self.value)
    self.link = l
    save
  end

  def set_or_create_global_link
    gl = GlobalLink.where(:global_id => self.global_id, :link_id => self.link_id)[0] || GlobalLink.create(:global_id => self.global_id, :link_id => self.link_id)
    self.global_link = gl
    save
  end

  def set_or_create_link_user
    lu = LinkUser.where(:user_id => self.user_id, :link_id => self.link_id)[0] || LinkUser.create(:user_id => self.user_id, :link_id => self.link_id)
    self.link_user = lu
    save
  end
  
  def set_or_create_global_node_user_and_node_models
    gnu_to = GlobalNodeUser.where(:global_id => self.global_id, :node_id => self.node_to_id, :user_id => self.user_id)[0] || GlobalNodeUser.create(:global_id => self.global_id, :node_id => self.node_to_id, :user_id => self.user_id)
    self.global_node_user_to = gnu_to
    gnu_from = GlobalNodeUser.where(:global_id => self.global_id, :node_id => self.node_from_id, :user_id => self.user_id)[0] || GlobalNodeUser.create(:global_id => self.global_id, :node_id => self.node_from_id, :user_id => self.user_id)
    self.global_node_user_from = gnu_from

    nu_to = NodeUser.where(:node_id => self.node_to_id, :user_id => self.user_id)[0] || NodeUser.create(:node_id => self.node_to_id, :user_id => self.user_id)
    self.node_user_to = nu_to
    nu_from = NodeUser.where(:node_id => self.node_from_id, :user_id => self.user_id)[0] || NodeUser.create(:node_id => self.node_from_id, :user_id => self.user_id)
    self.node_user_from = nu_from

    gn_to = GlobalNode.where(:global_id => self.global_id, :node_id => self.node_to_id)[0] || GlobalNode.create(:global_id => self.global_id, :node_id => self.node_to_id)
    self.global_node_to = gn_to
    gn_from = GlobalNode.where(:global_id => self.global_id, :node_id => self.node_from_id)[0] || GlobalNode.create(:global_id => self.global_id, :node_id => self.node_from_id)
    self.global_node_from = gn_from

    save
  end

  def delete_link_if_allowed
    if link.global_link_users_count < 2
      link.destroy
    end
  end

  def delete_global_link_if_allowed
    if global_link.global_link_users_count < 2
      global_link.destroy
    end
  end

  def delete_link_user_if_allowed
    if link_user.global_link_users_count < 2
      link_user.destroy
    end
  end

#  def turn_off_node_ignore
#    unless value == 0 || value.blank?
#      node_to.update_attributes(:ignore=>false)
#      node_from.update_attributes(:ignore=>false)
#    end
#    unless value == 0 || value.blank?
#      nodes_global_to.update_attributes(:ignore=>false)
#      nodes_global_from.update_attributes(:ignore=>false)
#    end
#  end  
#
#  def turn_on_node_ignore
#    unless value == 0 || value.blank?
#      if !node_to.has_links?
#	node_to.update_attributes(:ignore=>true)
#      elsif !node_from.has_links?
#	node_from.update_attributes(:ignore=>true)
#      end
#    end
#    unless value == 0 || value.blank?
#      if !nodes_global_to.has_links?
#        nodes_global_to.update_attributes(:ignore=>true)
#      elsif !nodes_global_from.has_links?
#        nodes_global_from.update_attributes(:ignore=>true)
#      end
#    end
#  end  

  def update_caches
    self.node_to.upvotes_count = GlobalLinkUser.count( :conditions => ["value = 1 AND node_to_id = ?",self.node_to_id])
    self.node_to.downvotes_count = GlobalLinkUser.count( :conditions => ["value = -1 AND node_to_id = ?",self.node_to_id])
    self.node_to.equivalents_count = GlobalLinkUser.count( :conditions => ["value = 0 AND node_to_id = ?",self.node_to_id])
    self.node_from.equivalents_count = GlobalLinkUser.count( :conditions => ["value = 0 AND node_from_id = ?",self.node_from_id])
    self.node_from.save
    self.node_to.save

    if self.global_node_user_to && self.global_node_user_from
      self.global_node_user_to.upvotes_count = GlobalLinkUser.count( :conditions => ["value = 1 AND global_node_user_to_id = ?",self.global_node_user_to_id])
      self.global_node_user_to.downvotes_count = GlobalLinkUser.count( :conditions => ["value = -1 AND global_node_user_to_id = ?",self.global_node_user_to_id])
      self.global_node_user_to.equivalents_count = GlobalLinkUser.count( :conditions => ["value = 0 AND global_node_user_to_id = ?",self.global_node_user_to_id])
      self.global_node_user_from.equivalents_count = GlobalLinkUser.count( :conditions => ["value = 0 AND global_node_user_from_id = ?",self.global_node_user_from_id])
      self.global_node_user_from.save
      self.global_node_user_to.save
    end

    if self.global_node_to && self.global_node_from
      self.global_node_to.upvotes_count = GlobalLinkUser.count( :conditions => ["value = 1 AND global_node_to_id = ?",self.global_node_to_id])
      self.global_node_to.downvotes_count = GlobalLinkUser.count( :conditions => ["value = -1 AND global_node_to_id = ?",self.global_node_to_id])
      self.global_node_to.equivalents_count = GlobalLinkUser.count( :conditions => ["value = 0 AND global_node_to_id = ?",self.global_node_to_id])
      self.global_node_from.equivalents_count = GlobalLinkUser.count( :conditions => ["value = 0 AND global_node_from_id = ?",self.global_node_from_id])
      self.global_node_from.save
      self.global_node_to.save
    end

    if self.global_node_user_to && self.global_node_user_from
      self.node_user_to.upvotes_count = GlobalLinkUser.count( :conditions => ["value = 1 AND node_user_to_id = ?",self.node_user_to_id])
      self.node_user_to.downvotes_count = GlobalLinkUser.count( :conditions => ["value = -1 AND node_user_to_id = ?",self.node_user_to_id])
      self.node_user_to.equivalents_count = GlobalLinkUser.count( :conditions => ["value = 0 AND node_user_to_id = ?",self.node_user_to_id])
      self.node_user_from.equivalents_count = GlobalLinkUser.count( :conditions => ["value = 0 AND node_user_from_id = ?",self.node_user_from_id])
      self.node_user_from.save
      self.node_user_to.save
    end
  end

end
