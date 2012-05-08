class Global < ActiveRecord::Base
  has_many :global_nodes, :class_name=>'GlobalNode'
  has_many :nodes, :through => :global_nodes
  has_many :global_users
  has_many :users, :through => :global_users
  has_many :global_links
  has_many :links, :through => :global_links
  has_many :global_link_users
  has_many :global_node_users

  validates_uniqueness_of :name

  def global_to_node_links(to_node, order="")
    if self.name == 'All'
      these_nodes = Node.all
      these_global_links = Link
      #only get most voted for link all over with each user only getting one vote
      this_order = 'users_count desc'
    else
      these_nodes = self.nodes
      these_global_links = self.global_links
      #only get most voted for link in global
      this_order = 'global_link_users_count desc'
    end
    constructed_links = []
    persisted_links = []
    these_nodes.each do |node|
      unless node == to_node
        this_link = these_global_links.where(:node_from_id => node.id, :node_to_id => to_node.id).order(this_order)[0]
        #first level of sorted - peristed from unpersisted
        unless this_link.blank?
          persisted_links << ((this_link.is_a?(GlobalLink)) ? this_link.link : this_link)
        else
          constructed_links << Link.new(:node_from_id=>node.id, :node_to_id=>to_node.id)
        end
      end
    end
    all_links = constructed_links.concat(persisted_links)
    #second level of sorting - title, id etc may need reverse?
    all_links.sort!{ |a, b|  a.node_from.title <=> b.node_from.title }
    all_links
  end

  def global_from_node_links(from_node, order="")
    if self.name == 'All'
      these_nodes = Node.all
      these_global_links = Link
      #only get most voted for link all over with each user only getting one vote
      this_order = 'users_count desc'
    else
      these_nodes = self.nodes
      these_global_links = self.global_links
      #only get most voted for link in global
      this_order = 'global_link_users_count desc'
    end
    constructed_links = []
    persisted_links = []
    these_nodes.each do |node|
      unless node == from_node
        this_link = these_global_links.where(:node_from_id => from_node.id, :node_to_id => node.id).order(this_order)[0]
        #first level of sorted - peristed from unpersisted
        unless this_link.blank?
          persisted_links << ((this_link.is_a?(GlobalLink)) ? this_link.link : this_link)
        else
          constructed_links << Link.new(:node_from_id=>from_node.id, :node_to_id=>node.id)
        end
      end
    end
    all_links = constructed_links.concat(persisted_links)
    #second level of sorting - title, id etc may need reverse?
    all_links.sort!{ |a, b|  a.node_to.title <=> b.node_to.title }
    all_links
  end

end
