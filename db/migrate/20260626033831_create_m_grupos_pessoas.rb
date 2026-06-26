class CreateMGruposPessoas < ActiveRecord::Migration[8.1]
  def change
    create_table :m_grupos_pessoas do |t|
      t.references :g_pessoa, null: false, foreign_key: true
      t.references :m_grupo, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :m_grupos_pessoas, :deleted_at
  end
end
