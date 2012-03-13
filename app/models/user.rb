class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :nodes  
  has_many :user_nodes_globals  
  has_many :nodes_globals, :through=> :user_nodes_globals 
  has_many :user_links, :dependent => :destroy
  has_many :links, :through => :user_links
  has_many :globals_users
  has_many :globals, :through => :globals_users
  has_many :user_globals_links
  has_many :globals_links, :through => :user_globals_links

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  
  def update_association(old_link, new_link_attributes)
    new_link, removed = nil
    transaction do
      removed = UserLink.where(:user_id=>self.id, :link_id=>old_link.id)[0].try(:destroy) 
      new_link = Link.where(new_link_attributes).first || Link.create(new_link_attributes)
      new_link.users << self
      # should really do this after create for user link - to trigger increment... this isn't tested but fuck it.
      if removed
        removed.save!
      end
      new_link.reload
      new_link.save!
    end 
    return (new_link.present? && (removed.present? && !removed.persisted?)) ? new_link : nil 
  end

  def create_association(new_link_attributes)
    new_link, created = nil
    transaction do
      new_link = Link.where(new_link_attributes)[0] || Link.create(new_link_attributes)
      new_link.users << self
      # should really do this after create for user link - to trigger increment... this isn't tested but fuck it.
      new_link.reload
      new_link.save!
    end 
    return (new_link.present? && new_link.persisted?) ? new_link : nil 
  end

  #no longer used
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

  #no longer used
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

end
