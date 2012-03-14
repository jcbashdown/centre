#class Node < ActiveRecord::Base
#  validates :title, :presence => true, :uniqueness => true
#
#  has_many :link_ins, :foreign_key => "node_to_id", :class_name => "Link"
#  has_many :link_tos, :foreign_key => "node_from_id", :class_name => "Link"
#
#  has_many :node_tos, :through => :link_tos, :class_name => "Node", :foreign_key => "node_to_id", :source=>:node_to
#  has_many :node_froms, :through => :link_ins, :class_name => "Node", :foreign_key => "node_from_id", :source=>:node_from
#
#  has_many :nodes_globals
#  has_many :globals, :through=>:nodes_globals
#  belongs_to :user
#  
#  accepts_nested_attributes_for :link_ins, :allow_destroy => true
#  accepts_nested_attributes_for :link_tos, :allow_destroy => true
#
#  def construct_to_node_links
#    links = []
#    Node.all.each do |node|
#      unless node == self
#        # could use build for things like this?
#        links << Link.new(:node_from=>node, :node_to=>self)
#      end
#    end
#    links.sort!{ |a, b|  a.node_from.title <=> b.node_from.title }
#    links
#  end
#  def construct_from_node_links
#    links = []
#    Node.all.each do |node|
#      unless node == self
#        # could use build for things like this?
#        links << Link.new(:node_from=>self, :node_to=>node)
#      end
#    end
#    links.sort!{ |a, b|  a.node_to.title <=> b.node_to.title }
#    links
#  end
#
#  def all_with_link_ids
#    nodes = []
#    Node.all.each do |node|
#      unless node.id==self.id
#        link_to = Link.find_by_node_from_id_and_node_to_id(self.id, node.id)
#        link_in = Link.find_by_node_from_id_and_node_to_id(node.id, self.id)
#        link_to = link_to ? link_to : Link.new(:node_from => self, :node_to=>node)
#        link_in = link_in ? link_in : Link.new(:node_from => node, :node_to=>self)
#        hash = {:node=>node, :link_in=>link_in, :link_to=>link_to}
#        nodes << hash
#      end
#    end
#    nodes
#  end
#
#  def has_links?
#    if self.link_tos.count > 0 || self.link_ins.count > 0
#      true
#    else
#      false
#    end
#  end
#
#  def sum_votes(vote_type)
#    links = Link.where('value = ? AND node_to_id = ?', vote_type, self.id)
#    sum = 0
#    if !links.empty?
#      links.each do |link|
#        sum = sum+link.users_count
#      end
#    end
#    sum
#  end
#
#  #This is for page rank
#  def build_link_array
#    #link value is positive links is proportion pos links = for 3 positive 2 negative 3/5
#    #so if node one links to node two 5 times upvotes (node_one.link_tos == 5). and 3 of the five are positive #Link.find.where(node_to = node_two.id AND value = 1).count
#    array = []
#    Node.all.each do |node|
#      unless node.ignore
#        to_id = node.id
#        from_id = self.id
#        fraction_of_link = 0.0
#        unless to_id == from_id
#          down = 0.0
#          up = 0.0
#          if link = Link.where("node_from_id = #{from_id} AND node_to_id = #{to_id} AND value = -1")[0]
#            down = Float(link.users_count)
#          end
#          if link = Link.where("node_from_id = #{from_id} AND node_to_id = #{to_id} AND value = 1")[0]
#            up = Float(link.users_count)
#          end
#          unless up == 0.0
#            fraction_of_link = up/(up+down)
#          end
#        end
#        array << fraction_of_link
#      end
#    end
#    array
#  end
#
#end
