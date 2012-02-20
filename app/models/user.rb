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
    links = []
    Node.all.each do |node|
      unless node == from_node
        links << Link.find_or_initialize_by_node_from_and_node_to(self.id,from_node.id,node.id)
      end
    end 
  end

end
