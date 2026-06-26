class CreateUPerfisFuncoes < ActiveRecord::Migration[8.1]
  def change
    create_table :u_perfis_funcoes do |t|
      t.references :u_perfil, null: false, foreign_key: true
      t.references :u_funcao, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :u_perfis_funcoes, :deleted_at
  end
end
