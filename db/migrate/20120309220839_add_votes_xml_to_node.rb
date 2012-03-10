class AddVotesXmlToNode < ActiveRecord::Migration
  def change
    add_column :nodes, :votes_xml, :text
  end
end
