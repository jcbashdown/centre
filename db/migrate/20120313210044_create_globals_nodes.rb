class CreateGlobalsNodes < ActiveRecord::Migration
  def change
    create_table :globals_nodes do |t|
      t.text :node_xml
      t.integer :global_id
      t.integer :node_id
      t.integer :equivalents_count
      t.integer :upvotes_count
      t.integer :downvotes_count
      t.boolean :ignore
      t.boolean :is_conclusion
      t.float :page_rank

      t.timestamps
    end
  end
end
