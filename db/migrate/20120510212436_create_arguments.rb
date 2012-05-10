class CreateArguments < ActiveRecord::Migration
  def change
    create_table :arguments do |t|
      t.text :content
      t.integer :subject_id
      t.string :subject_type
      t.string :type

      t.timestamps
    end
  end
end
