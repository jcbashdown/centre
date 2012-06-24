module LinkMixin
  def self.included(base)
    base.belongs_to :node_from, :class_name => "Node", :foreign_key=>'node_from_id'
    base.belongs_to :node_to, :class_name => "Node", :foreign_key=>'node_to_id'
    base.validates :node_from, :presence => true
    base.validates :node_to, :presence => true
  end
end

