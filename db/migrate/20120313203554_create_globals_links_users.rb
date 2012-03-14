class CreateGlobalsLinksUsers < ActiveRecord::Migration
  def change
    create_table :globals_links_users do |t|
      t.integer :global_id
      t.integer :user_id
      t.integer :link_id

      t.timestamps
    end
  end
end
