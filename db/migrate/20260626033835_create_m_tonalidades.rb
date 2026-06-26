class CreateMTonalidades < ActiveRecord::Migration[8.1]
  def change
    create_table :m_tonalidades do |t|
      t.string :descricao
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :m_tonalidades, :deleted_at
  end
end
