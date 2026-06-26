class CreateMArtistas < ActiveRecord::Migration[8.1]
  def change
    create_table :m_artistas do |t|
      t.string :descricao
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :m_artistas, :deleted_at
  end
end
