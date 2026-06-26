class CreateMArranjadores < ActiveRecord::Migration[8.1]
  def change
    create_table :m_arranjadores do |t|
      t.string :descricao
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :m_arranjadores, :deleted_at
  end
end
