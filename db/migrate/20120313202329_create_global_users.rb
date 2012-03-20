class CreateGlobalUsers < ActiveRecord::Migration
  def change
    create_table :global_users, :id=>false do |t|
      t.references :global
      t.references :user
      t.text :nodes_xml
    end
  end
end