class AddGroupIdToLink < ActiveRecord::Migration
  def change
    add_column :links, :group_id, :integer
    remove_column :links, :question_id
    add_index :links, :group_id
  end
end
