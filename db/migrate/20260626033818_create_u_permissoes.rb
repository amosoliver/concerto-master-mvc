class CreateUPermissoes < ActiveRecord::Migration[8.1]
  def change
    create_table :u_permissoes do |t|
      t.string :descricao
      t.string :controlador
      t.string :acao
      t.boolean :admin
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :u_permissoes, :deleted_at
  end
end
