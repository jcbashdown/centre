class GlobalsNodes < ActiveRecord::Base
  belongs_to :global
  belongs_to :node

  before_save :update_xml, :update_global_xml
  before_destroy :update_global_xml

  def update_xml

  end

  def update_global_xml

  end
end
