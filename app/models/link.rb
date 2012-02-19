class Link < ActiveRecord::Base
  belongs_to :source_node, :foreign_key => "node_from", :class_name => "Node"
  belongs_to :target_node, :foreign_key => "node_to", :class_name => "Node"
  has_many :user_links, :dependent => :destroy
  has_many :users, :through => :user_links
  has_and_belongs_to_many :globals
  # do we definitely want to limit to having a support or oppose relation? What about undecided or related?
  #spec this
  validates :node_from, :presence => true
  validates :node_to, :presence => true

  after_save :change_counter_cache, :turn_off_node_ignore
  after_destroy :decrement_counter_cache, :turn_on_node_ignore
  after_create :set_all
  
  def turn_off_node_ignore
    unless value == 0 || value.blank?
      target_node.update_attributes(:ignore=>false)
      source_node.update_attributes(:ignore=>false)
    end
  end  
  def turn_on_node_ignore
    unless value == 0 || value.blank?
      if !target_node.has_links?
        target_node.update_attributes(:ignore=>true)
      elsif !source_node.has_links?
        source_node.update_attributes(:ignore=>true)
      end
    end
  end  

  def set_all
    # do this with global setting
    all = Global.find_by_name("All")
    all.links << self
    all.save!
  end  

  def change_counter_cache
    node = target_node
    node.upvotes_count = node.sum_votes(1)
    node.downvotes_count = node.sum_votes(-1)
    node.equivalents_count = node.sum_votes(0)
    node.save!
  end
  
  def decrement_counter_cache
    vote = self.value
    node = target_node
    if vote == 1
      node.upvotes_count-=users_count
    elsif vote == -1
      node.downvotes_count-=users_count
    else
      node.equivalents_count-=users_count
    end
    node.save!
  end

  
end
