class GlobalNode < ActiveRecord::Base
  searchable do
    text :title
  end
  belongs_to :global
  belongs_to :node
  has_many :global_node_users

  validates :node, :presence => true

  validates_uniqueness_of :node_id, :scope => [:global_id]

  before_save :update_xml, :update_global_xml
  before_destroy :update_global_xml

  def update_xml

  end

  def update_global_xml

  end
end
