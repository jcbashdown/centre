class NodesGlobal < ActiveRecord::Base
  has_many :link_ins, :foreign_key => "nodes_global_to_id", :class_name => "Link"
  has_many :link_tos, :foreign_key => "nodes_global_from_id", :class_name => "Link"

  has_many :nodes_global_tos, :through => :link_tos, :class_name => "NodesGlobal", :foreign_key => "nodes_global_to_id", :source=>:nodes_global_to
  has_many :nodes_global_froms, :through => :link_ins, :class_name => "NodesGlobal", :foreign_key => "nodes_global_from_id", :source=>:nodes_global_from
  belongs_to :node
  belongs_to :global
  has_many :user_nodes_globals
  has_many :users, :through => :user_nodes_globals

  before_save :set_default_xml

  after_destroy :decrement_global_counter_cache

  def construct_to_node_links
    links = []
    NodesGlobal.all.each do |node|
      unless node == self
        # could use build for things like this?
        links << Link.new(:nodes_global_from=>node, :node_from=>node.node, :nodes_global_to=>self, :node_to=>self.node)
      end
    end
    links.sort!{ |a, b|  a.node_from.title <=> b.node_from.title }
    links
  end
  def construct_from_node_links
    links = []
    NodesGlobal.all.each do |node|
      unless node == self
        # could use build for things like this?
        links << Link.new(:nodes_global_from=>self, :node_from=>self.node, :nodes_global_to=>node, :node_to=>node.node)
      end
    end
    links.sort!{ |a, b|  a.node_to.title <=> b.node_to.title }
    links
  end

  def decrement_global_counter_cache
    Global.decrement_counter( 'nodes_count', node.id )
  end 

  def set_default_xml
    self.votes_xml ||= node.to_xml
  end

  def sum_votes(vote_type)
    links = Link.where('value = ? AND nodes_global_to_id = ?', vote_type, self.id)
    sum = 0
    if !links.empty?
      links.each do |link|
        sum = sum+link.users_count
      end
    end
    sum
  end

  def has_links?
    if self.link_tos.count > 0 || self.link_ins.count > 0
      true
    else
      false
    end
  end
end
