class CreateMEventosMusicas < ActiveRecord::Migration[8.1]
  def change
    create_table :m_eventos_musicas do |t|
      t.references :m_evento, null: false, foreign_key: true
      t.references :m_musica, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :m_eventos_musicas, :deleted_at
  end
end
