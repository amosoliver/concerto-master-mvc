class DropExamples < ActiveRecord::Migration[8.0]
  def up
    drop_table :examples
  end

  def down
    create_table :examples do |t|
      t.string :name
      t.text :description
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :examples, :deleted_at
  end
end
