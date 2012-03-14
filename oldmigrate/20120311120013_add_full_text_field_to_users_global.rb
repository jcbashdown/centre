class AddFullTextFieldToUsersGlobal < ActiveRecord::Migration
  def change
    add_column :globals_users, :full_text, :text
  end
end
