class Link < ActiveRecord::Base
  belongs_to :source_node, :foreign_key => "node_from", :class_name => "Node"
  belongs_to :target_node, :foreign_key => "node_to", :class_name => "Node"
  has_many :user_links, :dependent => :destroy
  has_many :users, :through => :user_links
  # do we definitely want to limit to having a support or oppose relation? What about undecided or related?
  #spec this
  validates :node_from, :presence => true
  validates :node_to, :presence => true

  after_save :increment_counter_cache

  after_destroy :decrement_counter_cache

  def increment_counter_cache
    vote = self.value
    node = target_node
    if vote == 1
      node.upvotes_count = users_count
    elsif vote == -1
      node.downvotes_count = users_count
    else
      node.equivalents_count = users_count
    end
    node.save!
  end
  
  def decrement_counter_cache
    vote = self.value
    node = target_node
    if vote == 1
      node.upvotes_count-=1
    elsif vote == -1
      node.downvotes_count-=1
    else
      node.equivalents_count-=1 
    end
    node.save!
    
  end
  
end
