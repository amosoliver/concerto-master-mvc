class CreateMEventos < ActiveRecord::Migration[8.1]
  def change
    create_table :m_eventos do |t|
      t.string :descricao
      t.datetime :data_inicio
      t.datetime :data_fim
      t.references :g_predio, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :m_eventos, :deleted_at
  end
end
