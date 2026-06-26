class CreateUPerfis < ActiveRecord::Migration[8.1]
  def change
    create_table :u_perfis do |t|
      t.string :descricao
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :u_perfis, :deleted_at
  end
end
