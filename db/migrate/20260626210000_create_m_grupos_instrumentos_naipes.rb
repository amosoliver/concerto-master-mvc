class CreateMGruposInstrumentosNaipes < ActiveRecord::Migration[8.1]
  def change
    create_table :m_grupos_instrumentos_naipes do |t|
      t.references :m_grupo, null: false, foreign_key: true
      t.references :g_instrumento_naipe, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :m_grupos_instrumentos_naipes, :deleted_at
  end
end
