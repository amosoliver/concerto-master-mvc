class CreateMEnsaioEventos < ActiveRecord::Migration[8.1]
  def change
    create_table :m_ensaio_eventos do |t|
      t.references :m_ensaio, null: false, foreign_key: true
      t.references :m_evento, null: false, foreign_key: true
      t.references :g_entidade, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :m_ensaio_eventos, :deleted_at
    add_index :m_ensaio_eventos, [:m_ensaio_id, :m_evento_id], unique: true, name: "index_m_ensaio_eventos_on_ensaio_and_evento"
  end
end
