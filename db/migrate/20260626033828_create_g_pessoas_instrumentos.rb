class CreateGPessoasInstrumentos < ActiveRecord::Migration[8.1]
  def change
    create_table :g_pessoas_instrumentos do |t|
      t.references :g_pessoa, null: false, foreign_key: true
      t.references :g_instrumento_naipe, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :g_pessoas_instrumentos, :deleted_at
  end
end
