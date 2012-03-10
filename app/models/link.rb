class Link < ActiveRecord::Base
  belongs_to :node_from, :class_name => "Node", :foreign_key=>'node_from_id'
  belongs_to :node_to, :class_name => "Node", :foreign_key=>'node_to_id'

  has_many :user_links, :dependent => :destroy
  has_many :users, :through => :user_links
  has_many :globals_links
  has_many :globals, :through => :globals_links
  # do we definitely want to limit to having a support or oppose relation? What about undecided or related?
  #spec this
  validates :node_from, :presence => true
  validates :node_to, :presence => true

  after_save :change_counter_cache, :turn_off_node_ignore
  after_destroy :decrement_counter_cache, :turn_on_node_ignore
  after_create :set_all
  
  def turn_off_node_ignore
    unless value == 0 || value.blank?
      node_to.update_attributes(:ignore=>false)
      node_from.update_attributes(:ignore=>false)
    end
  end  
  def turn_on_node_ignore
    unless value == 0 || value.blank?
      if !node_to.has_links?
        node_to.update_attributes(:ignore=>true)
      elsif !node_from.has_links?
        node_from.update_attributes(:ignore=>true)
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
    node = node_to
    node.upvotes_count = node.sum_votes(1)
    node.downvotes_count = node.sum_votes(-1)
    node.equivalents_count = node.sum_votes(0)
    node.save!
  end
  
  def decrement_counter_cache
    vote = self.value
    node = node_to
    if vote == 1
      node.upvotes_count-=users_count
    elsif vote == -1
      node.downvotes_count-=users_count
    else
      node.equivalents_count-=users_count
    end
    node.save!
  end
  
  def add_text_to_global(global)
    #strip non word chars/make safe, strip white space
    unless global.name == "All"
      text = global.full_text
      node_from_text = node_from.title
      node_to_text = node_to.title
      if value == 1
        descriptor = "+"
        match = text.match(/#{Regexp.quote(node_to_text)}\n\s{2}#{Regexp.quote(descriptor)}/)
        unless match
          #start the first plus of minus
          match = text.match(/#{Regexp.quote(node_to_text)}\n\s{2}/)
        end
        # for each match
        match_index = match.end(0)
        text.insert(match_index, descriptor+node_text)
      elsif value == -1
        descriptor = "-"
        match = text.match(/#{Regexp.quote(node_to_text)}\n\s{2}#{Regexp.quote(descriptor)}/)
        unless match
          #start the first plus of minus
          match = text.match(/#{Regexp.quote(node_to_text)}\n\s{2}/)
        end
        # for each match
        match_index = match.end(0)
        text.insert(match_index, descriptor+node_text)
      end
    end
  end
end
