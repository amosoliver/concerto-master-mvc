class CreateMPessoasFuncoes < ActiveRecord::Migration[8.1]
  def change
    create_table :m_pessoas_funcoes do |t|
      t.references :g_pessoa, null: false, foreign_key: true
      t.references :u_funcao, null: false, foreign_key: true
      t.boolean :principal
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :m_pessoas_funcoes, :deleted_at
  end
end
