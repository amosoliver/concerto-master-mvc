class CreateGEntidades < ActiveRecord::Migration[8.1]
  def change
    create_table :g_entidades do |t|
      t.string :descricao
      t.references :g_estado, null: false, foreign_key: true
      t.references :g_municipio, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :g_entidades, :deleted_at
  end
end
