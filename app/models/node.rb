class Node < ActiveRecord::Base
  validates :title, :presence => true, :uniqueness => true
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

  def build_link_array
    #link value is positive links is proportion pos links = for 3 positive 2 negative 3/5
    #so if node one links to node two 5 times upvotes (node_one.link_tos == 5). and 3 of the five are positive #Link.find.where(node_to = node_two.id AND value = 1).count
    array = []
    Node.all.each do |node|
      unless node.ignore
        to_id = node.id
        from_id = self.id
        fraction_of_link = 0.0
        unless to_id == from_id
          down = 0.0
          up = 0.0
          if link = Link.where("node_from = #{from_id} AND node_to = #{to_id} AND value = -1")[0]
            down = Float(link.users_count)
          end
          if link = Link.where("node_from = #{from_id} AND node_to = #{to_id} AND value = 1")[0]
            up = Float(link.users_count)
          end
          unless up == 0.0
            fraction_of_link = up/(up+down)
          end
        end
        array << fraction_of_link
      end
    end
    array
  end

  def has_links?
    if ((self.upvotes_count+self.downvotes_count) > 0)
      true
    else
      false
    end
  end
  
end
