class NodesGlobal < ActiveRecord::Base
  belongs_to :node
  belongs_to :global, :counter_cache => :nodes_count 
end
