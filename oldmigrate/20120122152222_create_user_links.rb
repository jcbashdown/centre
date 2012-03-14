class CreateUserLinks < ActiveRecord::Migration
  def change
    create_table :user_links do |t|
      t.string :user_id
      t.text :link_id

      t.timestamps
    end
  end
end
