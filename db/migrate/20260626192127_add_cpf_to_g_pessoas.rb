class AddCpfToGPessoas < ActiveRecord::Migration[8.1]
  def change
    add_column :g_pessoas, :cpf, :string
  end
end
