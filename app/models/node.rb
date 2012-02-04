class Node < ActiveRecord::Base
  validates :title, :presence => true
  has_many :link_ins, :foreign_key => "node_to", :class_name => "Link"
  has_many :link_tos, :foreign_key => "node_from", :class_name => "Link"
  has_many :target_nodes, :through => :link_tos, :class_name => "Node", :foreign_key => "node_from"
  has_many :source_nodes, :through => :link_ins, :class_name => "Node", :foreign_key => "node_to"
  has_many :nodes_globals
  has_many :globals, :through=>:nodes_globals
  belongs_to :user
  
  accepts_nested_attributes_for :link_ins, :allow_destroy => true#, :reject_if => :reject_link
  accepts_nested_attributes_for :link_tos, :allow_destroy => true#, :reject_if => :reject_link
  after_create :set_all
  
  def set_all
    # do this with global setting
    all = Global.find_by_name("All")
    all.nodes << self
    all.save!
  end  

  def reject_link(hash)
    p hash
    hash.each do |key|
      unless key=='user_id'
        return hash[key].blank?
      end
    end 
    # reject if not real link ids (either)
  end
  
  def all_with_link_ids
    nodes = []
    Node.all.each do |node|
      unless node.id==self.id
        link_to = Link.find_by_node_from_and_node_to(self.id, node.id)
        link_in = Link.find_by_node_from_and_node_to(node.id, self.id)
        link_to = link_to ? link_to : Link.new(:node_from => self.id, :node_to=>node.id)
        link_in = link_in ? link_in : Link.new(:node_from => node.id, :node_to=>self.id)
        hash = {:node=>node, :link_in=>link_in, :link_to=>link_to}
        nodes << hash
      end
    end
    nodes
  end
  
end
