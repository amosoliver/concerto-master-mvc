class CreateMTiposGrupos < ActiveRecord::Migration[8.1]
  def change
    create_table :m_tipos_grupos do |t|
      t.string :descricao
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :m_tipos_grupos, :deleted_at
  end
end
