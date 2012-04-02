class CreateGlobalLinkUsers < ActiveRecord::Migration
  def change
    create_table :global_link_users do |t|
      t.references :global
      t.references :user
      t.references :link
      t.references :link_user
      t.references :global_link
      t.integer :node_from_id
      t.integer :node_to_id
      t.integer :value

      t.timestamps
    end
  end
end
