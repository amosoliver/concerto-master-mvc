class CreateGMunicipios < ActiveRecord::Migration[8.1]
  def change
    create_table :g_municipios do |t|
      t.string :descricao
      t.string :codigo_ibge
      t.references :g_estado, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :g_municipios, :deleted_at
  end
end
