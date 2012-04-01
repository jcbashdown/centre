class User < ActiveRecord::Base
  has_many :globals_users
  has_many :globals, :through=>:global_users
  has_many :node_users
  has_many :nodes, :through => :node_users
  has_many :link_users
  has_many :link, :through => :link_users
  has_many :global_node_users
  has_many :global_link_users
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  
end
