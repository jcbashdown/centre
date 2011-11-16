class Link < ActiveRecord::Base
  belongs_to :source_node, :foreign_key => "node_from", :class_name => "Node"
  belongs_to :target_node, :foreign_key => "node_to", :class_name => "Node"
end
