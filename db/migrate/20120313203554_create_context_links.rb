#links go everywhere by default for the purpose of page rank? though not for counts? (except when private) or entirely do away with question links and always do all?
class CreateContextLinks < ActiveRecord::Migration
  def change
    create_table :context_links do |t|
      #for activity, for callback (could do without db here)
      t.references :question
      t.references :user
      #for user counts, know if destroy, know what active
      t.references :global_link
      t.references :user_link
      t.references :question_link
      #for equivalents etc counts, could do through user counts on sub - quicker? custom counter cache then. does this or this alt double count users between globals?
      t.integer :global_node_from_id
      t.integer :global_node_to_id
      t.integer :context_node_from_id
      t.integer :context_node_to_id
      t.integer :question_node_from_id
      t.integer :question_node_to_id
      t.integer :user_node_from_id
      t.integer :user_node_to_id
      #privacy, how will this work?
      t.boolean :private, :default=>false
      #to determine what vote it gives
      t.string :type

      t.timestamps
    end
    add_index :context_links, :question_id
    add_index :context_links, :user_id
    add_index :context_links, :global_link_id
    add_index :context_links, :user_link_id
    add_index :context_links, :question_link_id
    add_index :context_links, :type
    #intersection index really needed here
  end
end