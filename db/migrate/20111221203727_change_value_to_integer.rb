class ChangeValueToInteger < ActiveRecord::Migration
  def up
    change_column :links, :value, :integer
  end

  def down
    change_column :links, :value, :boolean
  end
end
