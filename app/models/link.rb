class Link < ActiveRecord::Base
  belongs_to :source_node, :foreign_key => "node_from", :class_name => "Node"
  belongs_to :target_node, :foreign_key => "node_to", :class_name => "Node"
  has_many :user_links, :dependent => :destroy
  has_many :users, :through => :user_links
  # do we definitely want to limit to having a support or oppose relation? What about undecided or related?
  #spec this
  validates :node_from, :presence => true
  validates :node_to, :presence => true
  
end
