class AddFullTextFieldToGlobals < ActiveRecord::Migration
  def change
    add_column :globals, :full_text, :text
  end
end
