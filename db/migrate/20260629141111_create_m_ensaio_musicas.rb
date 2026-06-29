class CreateMEnsaioMusicas < ActiveRecord::Migration[8.1]
  def change
    create_table :m_ensaio_musicas do |t|
      t.references :m_ensaio, null: false, foreign_key: true
      t.references :m_evento_musica, null: false, foreign_key: true
      t.references :g_entidade, null: false, foreign_key: true
      t.string :observacao
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :m_ensaio_musicas, :deleted_at
  end
end
