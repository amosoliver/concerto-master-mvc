class AddDeviseToGUsuarios < ActiveRecord::Migration[8.1]
  def change
    add_column :g_usuarios, :remember_created_at, :datetime
  end
end
