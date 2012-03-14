class CreateGlobalsLinks < ActiveRecord::Migration
  def change 
    create_table :globals_links, :id => false do |t|
      t.integer :link_id
      t.integer :global_id
    end
  end
end
