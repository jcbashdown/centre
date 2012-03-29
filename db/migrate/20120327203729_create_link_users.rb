class CreateLinkUsers < ActiveRecord::Migration
  def change
    create_table :link_users do |t|
      t.references :link
      t.references :user
      t.integer :global_link_users_count

      t.timestamps
    end
  end
end
