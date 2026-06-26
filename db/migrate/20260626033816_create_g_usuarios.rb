class CreateGUsuarios < ActiveRecord::Migration[8.1]
  def change
    create_table :g_usuarios do |t|
      t.string :email
      t.string :encrypted_password
      t.boolean :ativo
      t.references :g_pessoa, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :g_usuarios, :deleted_at
  end
end
