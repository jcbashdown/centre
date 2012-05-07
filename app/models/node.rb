class Node < ActiveRecord::Base
  searchable do
    text :title
    integer :id
    double :page_rank
    time :created_at
  end
  has_many :global_nodes, :class_name=>'GlobalNode'
  has_many :globals, :through => :global_nodes
  has_many :global_node_users
  has_many :node_users
  has_many :users, :through => :node_users

  has_many :link_ins, :foreign_key => "node_to_id", :class_name => "Link"
  has_many :link_tos, :foreign_key => "node_from_id", :class_name => "Link"

  has_many :node_tos, :through => :link_tos, :class_name => "Node", :foreign_key => "node_to_id", :source=>:node_to
  has_many :node_froms, :through => :link_ins, :class_name => "Node", :foreign_key => "node_from_id", :source=>:node_from

  validates_uniqueness_of :title
  validates :title, :presence => true

  def node_hash
    {:title => self.title, :body=> self.body}
  end
end
