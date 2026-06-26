class CreateGInstrumentos < ActiveRecord::Migration[8.1]
  def change
    create_table :g_instrumentos do |t|
      t.string :descricao
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :g_instrumentos, :deleted_at
  end
end
