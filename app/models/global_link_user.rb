class GlobalLinkUser < ActiveRecord::Base
  belongs_to :node_from, :class_name => "Node", :foreign_key=>'node_from_id'
  belongs_to :node_to, :class_name => "Node", :foreign_key=>'node_to_id'
  #make this work for this rel or use else
  belongs_to :global_node_user_from, :class_name => "GlobalNodeUser", :foreign_key=>'node_from_id', :counter_cache => :global_link_users_count
  belongs_to :global_node_user_to, :class_name => "GlobalNodeUser", :foreign_key=>'node_to_id', :counter_cache => :global_link_users_count

  belongs_to :global
  belongs_to :link, :counter_cache => true
  belongs_to :user
  belongs_to :link_user, :counter_cache => true
  belongs_to :global_link, :counter_cache => true

  #validates :node_from, :presence => true
  #validates :node_to, :presence => true
  after_create :set_or_create_link, :set_or_create_global_link, :set_or_create_link_user, :set_or_create_global_node_users#update xml
  after_destroy :delete_link_if_allowed, :delete_global_link_if_allowed, :delete_link_user_if_allowed, :delete_global_node_users_if_allowed#update xml

  validates_uniqueness_of :link_id, :scope => [:global_id, :user_id]
  validates_uniqueness_of :value, :scope => [:node_from_id, :node_to_id]
  
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
  
  def set_or_create_global_node_users

  end

  def delete_link_if_allowed

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

  def delete_global_node_users_if_allowed

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

#do with upvotes from rel with counter cache and condits like:
#class Order < ActiveRecord::Base
#  belongs_to :customer, :conditions => "active = 1"
#end
  def change_counter_cache
    node = node_to
    node.upvotes_count = node.sum_votes(1)
    node.downvotes_count = node.sum_votes(-1)
    node.equivalents_count = node.sum_votes(0)
    node.save!
    nodes_global = nodes_global_to
    nodes_global.upvotes_count = nodes_global.sum_votes(1)
    nodes_global.downvotes_count = nodes_global.sum_votes(-1)
    nodes_global.equivalents_count = nodes_global.sum_votes(0)
    nodes_global.save!
  end
  
  def decrement_counter_cache
    vote = self.value
    node = self.node_to
    if vote == 1
      node.upvotes_count-=users_count
    elsif vote == -1
      node.downvotes_count-=users_count
    else
      node.equivalents_count-=users_count
    end
    node.save!
    nodes_global = self.nodes_global_to
    if vote == 1
      nodes_global.upvotes_count-=users_count
    elsif vote == -1
      nodes_global.downvotes_count-=users_count
    else
      nodes_global.equivalents_count-=users_count
    end
    nodes_global.save!
  end

end
