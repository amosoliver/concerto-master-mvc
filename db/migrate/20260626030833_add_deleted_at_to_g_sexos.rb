class AddDeletedAtToGSexos < ActiveRecord::Migration[8.1]
  def change
    add_column :g_sexos, :deleted_at, :datetime
    add_index :g_sexos, :deleted_at
  end
end
