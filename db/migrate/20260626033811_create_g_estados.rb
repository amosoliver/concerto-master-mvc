class CreateGEstados < ActiveRecord::Migration[8.1]
  def change
    create_table :g_estados do |t|
      t.string :descricao
      t.string :sigla
      t.string :codigo_ibge
      t.references :g_pais, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :g_estados, :deleted_at
  end
end
