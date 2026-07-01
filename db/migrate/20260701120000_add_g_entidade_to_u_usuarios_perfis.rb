class AddGEntidadeToUUsuariosPerfis < ActiveRecord::Migration[8.1]
  def up
    add_reference :u_usuarios_perfis, :g_entidade, foreign_key: true

    execute <<~SQL.squish
      UPDATE u_usuarios_perfis
      SET g_entidade_id = g_pessoas.g_entidade_id
      FROM g_usuarios
      INNER JOIN g_pessoas ON g_pessoas.id = g_usuarios.g_pessoa_id
      WHERE g_usuarios.id = u_usuarios_perfis.g_usuario_id
        AND u_usuarios_perfis.g_entidade_id IS NULL
    SQL

    change_column_null :u_usuarios_perfis, :g_entidade_id, false
    add_index :u_usuarios_perfis, %i[g_usuario_id g_entidade_id]
  end

  def down
    remove_index :u_usuarios_perfis, %i[g_usuario_id g_entidade_id]
    remove_reference :u_usuarios_perfis, :g_entidade, foreign_key: true
  end
end
