class CreateUFuncoes < ActiveRecord::Migration[8.1]
  def change
    create_table :u_funcoes do |t|
      t.string :descricao
      t.references :u_tipo_funcao, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :u_funcoes, :deleted_at
  end
end
