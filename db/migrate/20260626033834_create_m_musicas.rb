class CreateMMusicas < ActiveRecord::Migration[8.1]
  def change
    create_table :m_musicas do |t|
      t.string :descricao
      t.references :m_compositor, null: false, foreign_key: true
      t.references :m_artista, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :m_musicas, :deleted_at
  end
end
