class Link < ActiveRecord::Base
  belongs_to :node_from, :class_name => "Node", :foreign_key=>'node_from_id'
  belongs_to :node_to, :class_name => "Node", :foreign_key=>'node_to_id'
  belongs_to :nodes_global_from, :class_name => "NodesGlobal", :foreign_key=>'nodes_global_from_id'
  belongs_to :nodes_global_to, :class_name => "NodesGlobal", :foreign_key=>'nodes_global_to_id'

  has_many :user_links, :dependent => :destroy
  has_many :users, :through => :user_links
  belongs_to :global

  validate :same_globals
  #validates :node_from, :presence => true
  #validates :node_to, :presence => true

  after_save :change_counter_cache, :turn_off_node_ignore, :set_global
  after_destroy :decrement_counter_cache, :turn_on_node_ignore

  def set_global
    self.global = nodes_global_from.global
  end
  
  def turn_off_node_ignore
    unless value == 0 || value.blank?
      node_to.update_attributes(:ignore=>false)
      node_from.update_attributes(:ignore=>false)
    end
    unless value == 0 || value.blank?
      nodes_global_to.update_attributes(:ignore=>false)
      nodes_global_from.update_attributes(:ignore=>false)
    end
  end  
  def turn_on_node_ignore
    unless value == 0 || value.blank?
      if !node_to.has_links?
	node_to.update_attributes(:ignore=>true)
      elsif !node_from.has_links?
	node_from.update_attributes(:ignore=>true)
      end
    end
    unless value == 0 || value.blank?
      if !nodes_global_to.has_links?
        nodes_global_to.update_attributes(:ignore=>true)
      elsif !nodes_global_from.has_links?
        nodes_global_from.update_attributes(:ignore=>true)
      end
    end
  end  

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

  private
  def same_globals
    nodes_global_from.global == nodes_global_to.global
  end
  
end
