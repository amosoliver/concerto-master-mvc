class CreateGPessoas < ActiveRecord::Migration[8.1]
  def change
    create_table :g_pessoas do |t|
      t.string :nome
      t.string :email
      t.references :g_entidade, null: false, foreign_key: true
      t.references :g_sexo, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :g_pessoas, :deleted_at
  end
end
