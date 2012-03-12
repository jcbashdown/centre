class CreateUserGlobalsLinks < ActiveRecord::Migration
  def change
    create_table :user_globals_links do |t|
      t.integer :user_id
      t.integer :globals_link_id

      t.timestamps
    end
  end
end
