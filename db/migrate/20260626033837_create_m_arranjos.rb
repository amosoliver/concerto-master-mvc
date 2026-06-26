class CreateMArranjos < ActiveRecord::Migration[8.1]
  def change
    create_table :m_arranjos do |t|
      t.references :m_musica, null: false, foreign_key: true
      t.references :m_arranjador, null: false, foreign_key: true
      t.references :m_tonalidade, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :m_arranjos, :deleted_at
  end
end
