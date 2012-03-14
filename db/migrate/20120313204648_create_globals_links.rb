class CreateGlobalsLinks < ActiveRecord::Migration
  def change
    create_table :globals_links do |t|
      t.integer :global_id
      t.integer :link_id
      t.integer :users_count

      t.timestamps
    end
  end
end
