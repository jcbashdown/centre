class CreateGlobalLinkUsers < ActiveRecord::Migration
  def change
    create_table :global_link_users do |t|
      t.references :global
      t.references :user
      t.references :link

      t.timestamps
    end
  end
end
