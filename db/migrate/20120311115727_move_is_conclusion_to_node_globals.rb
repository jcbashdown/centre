class MoveIsConclusionToNodeGlobals < ActiveRecord::Migration
  def up
    remove_column :nodes, :is_conclusion
    add_column :nodes_globals, :is_conclusion, :boolean, :default=>false
  end

  def down
    remove_column :nodes_globals, :is_conclusion
    add_column :nodes, :is_conclusion, :boolean, :default=>false
  end
end
