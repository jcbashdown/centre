class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :nodes  
  has_many :user_links, :dependent => :destroy
  has_many :links, :through => :user_links
  has_and_belongs_to_many :globals

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  after_create :set_all
  
  def set_all
    # do this with global setting
    all = Global.find_by_name("All")
    all.users << self
    all.save!
  end  
  
  def user_from_node_links(from_node, order="")
    constructed_links = []
    persisted_links = []
    Node.all.each do |node|
      unless node == from_node
        this_link = self.links.where('links.node_from_id = ? AND links.node_to_id = ?', from_node.id, node.id)
        #first level of sorted - peristed from unpersisted
        unless this_link.empty?
          persisted_links << this_link[0]
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
  def user_to_node_links(to_node, order="")
    constructed_links = []
    persisted_links = []
    Node.all.each do |node|
      unless node == to_node
        this_link = self.links.where('links.node_from_id = ? AND links.node_to_id = ?', node.id, to_node.id)
        #first level of sorted - peristed from unpersisted
        unless this_link.empty?
          persisted_links << this_link[0]
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

end
