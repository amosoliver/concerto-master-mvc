class AddPrimeiroAcessoToGUsuarios < ActiveRecord::Migration[8.1]
  def change
    add_column :g_usuarios, :primeiro_acesso, :boolean, default: true, null: false
  end
end
