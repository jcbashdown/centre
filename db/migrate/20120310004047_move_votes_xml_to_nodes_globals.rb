class MoveVotesXmlToNodesGlobals < ActiveRecord::Migration
  def change
    remove_column :nodes, :votes_xml
    add_column :nodes_globals, :votes_xml, :text
  end
end
