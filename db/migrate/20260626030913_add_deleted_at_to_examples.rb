class AddDeletedAtToExamples < ActiveRecord::Migration[8.1]
  def change
    add_column :examples, :deleted_at, :datetime
    add_index :examples, :deleted_at
  end
end
