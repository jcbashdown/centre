class GlobalNodeUser < ActiveRecord::Base
  belongs_to :global
  belongs_to :node
  belongs_to :user

  before_save :update_xml, :update_globals_user_xml
  after_create :create_globals_node, :set_all
  after_destroy :update_xml, :delete_globals_node, :delete_all
  
  protected
  def create_globals_node
    unless self.global.nodes.include? self.node
      self.global.nodes << self.node
    end
  end

  def set_all
    unless self.global.name == 'All'
      GlobalNodeUser.where(:user_id=>self.user.id, :node_id=>self.node.id, :global_id=>Global.find_by_name('All').id)[0] || GlobalNodeUser.create(:user=>self.user, :node=>self.node, :global=>Global.find_by_name('All'))
    end
  end

  def delete_globals_node
    GlobalNode.where(:global_id=>self.global.id, :node_id=>self.node.id)[0].destroy
  end

  def delete_all
    unless self.global.name == 'All'
      GlobalNodeUser.where(:user_id=>self.user.id, :node_id=>self.node.id, :global_id=>Global.find_by_name('All').id)[0].destroy
    end
  end

  def update_xml

  end

  def update_globals_user_xml

  end
end
