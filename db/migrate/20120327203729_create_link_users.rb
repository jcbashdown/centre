class CreateLinkUsers < ActiveRecord::Migration
  def change
    create_table :link_users do |t|
      t.relation :link_id
      t.relation :user_id

      t.timestamps
    end
  end
end
