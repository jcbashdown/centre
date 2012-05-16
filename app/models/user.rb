class User < ActiveRecord::Base
  has_many :globals_users
  has_many :globals, :through=>:global_users
  has_many :node_users
  has_many :nodes, :through => :node_users
  has_many :link_users
  has_many :links, :through => :link_users
  has_many :global_node_users
  has_many :global_link_users
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  
  def user_to_node_links(to_node, global, order="")
    if global.name == 'All'
      these_nodes = Node.all
    else
      these_nodes = global.nodes
    end
    constructed_links = []
    persisted_links = []
    these_link_users = self.links
    these_nodes.each do |node|
      from_node = node
      unless from_node == to_node
        this_link = these_link_users.where(:node_from_id => from_node.id, :node_to_id => to_node.id)
        unless this_link.empty?
          persisted_links << this_link[0]
        else
          constructed_links << Link.new(:node_from_id=> from_node.id, :node_to_id => to_node.id)
        end
      end
    end
    all_links = constructed_links.concat(persisted_links)
    #second level of sorting - title, id etc may need reverse?
    all_links.sort!{ |a, b|  a.node_from.title <=> b.node_from.title }
    all_links
  end

  def user_from_node_links(from_node, global, order="")
    if global.name == 'All'
      these_nodes = Node.all
    else
      these_nodes = global.nodes
    end
    constructed_links = []
    persisted_links = []
    these_link_users = self.links
    these_nodes.each do |node|
      to_node = node
      unless to_node == from_node
        this_link = these_link_users.where(:node_from_id => from_node.id, :node_to_id => to_node.id)
        unless this_link.empty?
          persisted_links << this_link[0]
        else
          constructed_links << Link.new(:node_from_id=>from_node.id, :node_to_id=>to_node.id)
        end
      end
    end
    all_links = constructed_links.concat(persisted_links)
    #second level of sorting - title, id etc may need reverse?
    all_links.sort!{ |a, b|  a.node_to.title <=> b.node_to.title }
    all_links
  end

end
