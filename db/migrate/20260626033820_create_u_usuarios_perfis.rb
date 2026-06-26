class CreateUUsuariosPerfis < ActiveRecord::Migration[8.1]
  def change
    create_table :u_usuarios_perfis do |t|
      t.references :u_perfil, null: false, foreign_key: true
      t.references :g_usuario, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :u_usuarios_perfis, :deleted_at
  end
end
