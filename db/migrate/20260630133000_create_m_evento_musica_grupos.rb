class CreateMEventoMusicaGrupos < ActiveRecord::Migration[8.1]
  def change
    create_table :m_evento_musica_grupos do |t|
      t.references :m_evento_musica, null: false, foreign_key: true
      t.references :m_grupo, null: false, foreign_key: true
      t.references :g_entidade, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :m_evento_musica_grupos, :deleted_at
    add_index :m_evento_musica_grupos, [:m_evento_musica_id, :m_grupo_id], unique: true, name: "index_m_evento_musica_grupos_on_item_and_grupo"
  end
end
