class ChangeVotesXmlDefaultToBlankString < ActiveRecord::Migration
  def change
    remove_column :nodes, :votes_xml
    add_column :nodes, :votes_xml, :text, :default=>""
  end
end
