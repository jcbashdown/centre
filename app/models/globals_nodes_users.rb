class GlobalsNodesUsers < ActiveRecord::Base
  belongs_to :global, :foreign_key=>'global_id'
  belongs_to :node, :foreign_key=>'node_id'
  belongs_to :user, :foreign_key=>'user_id'

  before_save :update_xml, :update_globals_user_xml
  after_create :create_globals_node, :set_all
  before_destroy :update_xml, :delete_globals_node, :delete_all
  
  protected
  def create_globals_node
    global.nodes << user
  end

  def set_all
    unless global.name == 'All'
      GlobalsNodesUsers.create(:user=>user, :node=>node, :global=>Global.find_by_name('All'))
    end
  end

  def delete_globals_node
    GlobalsNodes.where(:global=>global, :node=>node)[0].destroy
    global.nodes << user
  end

  def delete_all
    unless global.name == 'All' || GlobalsNodes.where(:global=>global, :node=>node).empty?
      GlobalsNodesUsers.where(:user=>user, :node=>node, :global=>Global.find_by_name('All'))[0].destroy
    end
  end

  def update_xml

  end

  def update_globals_user_xml

  end
end
