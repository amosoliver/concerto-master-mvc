class CreateGNaipes < ActiveRecord::Migration[8.1]
  def change
    create_table :g_naipes do |t|
      t.string :descricao
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :g_naipes, :deleted_at
  end
end
