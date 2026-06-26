class CreateGPredios < ActiveRecord::Migration[8.1]
  def change
    create_table :g_predios do |t|
      t.string :nome_fantasia
      t.string :cep
      t.string :logradouro
      t.string :bairro
      t.references :g_entidade, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :g_predios, :deleted_at
  end
end
