class Link < ActiveRecord::Base
  belongs_to :node_from, :class_name => "Node", :foreign_key=>'node_from_id'
  belongs_to :node_to, :class_name => "Node", :foreign_key=>'node_to_id'
  belongs_to :nodes_global_from, :class_name => "NodesGlobal", :foreign_key=>'nodes_global_from_id'
  belongs_to :nodes_global_to, :class_name => "NodesGlobal", :foreign_key=>'nodes_global_to_id'

  has_many :user_links, :dependent => :destroy
  has_many :users, :through => :user_links
  has_many :globals_links
  has_many :globals, :through => :globals_links

  #validates :node_from, :presence => true
  #validates :node_to, :presence => true

  after_save :change_counter_cache, :turn_off_node_ignore
  after_destroy :decrement_counter_cache, :turn_on_node_ignore
  after_create :set_all
  
  def turn_off_node_ignore
    unless value == 0 || value.blank?
      nodes_global_to.update_attributes(:ignore=>false)
      nodes_global_from.update_attributes(:ignore=>false)
    end
  end  
  def turn_on_node_ignore
    unless value == 0 || value.blank?
      if !nodes_global_to.has_links?
        nodes_global_to.update_attributes(:ignore=>true)
      elsif !nodes_global_from.has_links?
        nodes_global_from.update_attributes(:ignore=>true)
      end
    end
  end  

  def set_all
    # do this with global setting
    all = Global.find_by_name("All")
    all.links << self
    all.save!
  end  

  def change_counter_cache
    nodes_global = nodes_global_to
    nodes_global.upvotes_count = nodes_global.sum_votes(1)
    nodes_global.downvotes_count = nodes_global.sum_votes(-1)
    nodes_global.equivalents_count = nodes_global.sum_votes(0)
    nodes_global.save!
  end
  
  def decrement_counter_cache
    vote = self.value
    node = node_to
    if vote == 1
      node.upvotes_count-=users_count
    elsif vote == -1
      node.downvotes_count-=users_count
    else
      node.equivalents_count-=users_count
    end
    node.save!
  end
  
end
