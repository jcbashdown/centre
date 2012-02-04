class CreateGlobalsUsers < ActiveRecord::Migration
  def change
    create_table :globals_users, :id => false do |t|
      t.integer :user_id
      t.integer :global_id
    end
  end
end
