class CreateGPaises < ActiveRecord::Migration[8.1]
  def change
    create_table :g_paises do |t|
      t.string :descricao
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :g_paises, :deleted_at
  end
end
