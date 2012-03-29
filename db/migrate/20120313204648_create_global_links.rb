class CreateGlobalLinks < ActiveRecord::Migration
  def change
    create_table :global_links do |t|
      t.references :global
      t.references :link
      t.integer :users_count
      t.integer :global_link_users_count

      t.timestamps
    end
  end
end
