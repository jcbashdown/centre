module GlobalLinkMixin
  def self.included(base)
    base.belongs_to :global_node_to, :class_name => "GlobalNode", :foreign_key=>'global_node_to_id'
    base.belongs_to :global_node_from, :class_name => "GlobalNode", :foreign_key=>'global_node_from_id'
    base.belongs_to :global
  end
end

