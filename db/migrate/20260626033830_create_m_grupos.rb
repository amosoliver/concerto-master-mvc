class CreateMGrupos < ActiveRecord::Migration[8.1]
  def change
    create_table :m_grupos do |t|
      t.string :descricao
      t.references :g_entidade, null: false, foreign_key: true
      t.references :m_tipo_grupo, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :m_grupos, :deleted_at
  end
end
