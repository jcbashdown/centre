class CreateGlobalsUsers < ActiveRecord::Migration
  def change
    create_table :globals_users, :id=>false do |t|
      t.integer :global_id
      t.integer :user_id
      t.text :nodes_xml
    end
  end
end
