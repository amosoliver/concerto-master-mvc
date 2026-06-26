class CreateMCompositores < ActiveRecord::Migration[8.1]
  def change
    create_table :m_compositores do |t|
      t.string :descricao
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :m_compositores, :deleted_at
  end
end
