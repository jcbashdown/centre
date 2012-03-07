class NodesGlobal < ActiveRecord::Base
  belongs_to :node
  belongs_to :global
  after_destroy :decrement_global_counter_cache
  def decrement_global_counter_cache
    Global.decrement_counter( 'nodes_count', node.id )
  end 
end
