class AddTimeStampsToJoinModels < ActiveRecord::Migration
  def change
    add_column(:nodes_globals, :created_at, :datetime)
    add_column(:nodes_globals, :updated_at, :datetime)
    add_column(:globals_links, :created_at, :datetime)
    add_column(:globals_links, :updated_at, :datetime)
    add_column(:globals_users, :created_at, :datetime)
    add_column(:globals_users, :updated_at, :datetime)
  end
end
