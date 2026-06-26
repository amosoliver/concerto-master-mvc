class CreateUTiposFuncoes < ActiveRecord::Migration[8.1]
  def change
    create_table :u_tipos_funcoes do |t|
      t.string :descricao
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :u_tipos_funcoes, :deleted_at
  end
end
