class AddIgnoreToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :ignore, :boolean, :default=>true
  end
end
