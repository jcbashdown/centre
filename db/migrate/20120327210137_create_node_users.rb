class CreateNodeUsers < ActiveRecord::Migration
  def change
    create_table :node_users do |t|
      t.relation :node_id
      t.relation :user_id

      t.timestamps
    end
  end
end
