class NodesGlobal < ActiveRecord::Base
  belongs_to :node
  belongs_to :global

  before_save :set_default_xml

  after_destroy :decrement_global_counter_cache
  def decrement_global_counter_cache
    Global.decrement_counter( 'nodes_count', node.id )
  end 

  def set_default_xml
    self.votes_xml ||= ""
  end
end
