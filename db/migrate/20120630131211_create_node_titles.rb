class CreateNodeTitles < ActiveRecord::Migration
  def change
    create_table :node_titles do |t|
      t.text :title

      t.timestamps
    end
  end
end
