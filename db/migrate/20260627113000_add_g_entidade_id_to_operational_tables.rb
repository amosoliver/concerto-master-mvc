class AddGEntidadeIdToOperationalTables < ActiveRecord::Migration[8.1]
  TABLES = %i[
    g_pessoas_instrumentos
    m_musicas
    m_arranjos
    m_arranjos_instrumentos_naipes
    m_eventos
    m_eventos_musicas
    m_grupos_instrumentos_naipes
    m_grupos_pessoas
    m_pessoas_funcoes
  ].freeze

  def up
    TABLES.each do |table|
      add_reference table, :g_entidade, foreign_key: true
    end

    execute <<~SQL
      UPDATE g_pessoas_instrumentos
      SET g_entidade_id = g_pessoas.g_entidade_id
      FROM g_pessoas
      WHERE g_pessoas.id = g_pessoas_instrumentos.g_pessoa_id
    SQL

    execute <<~SQL
      UPDATE m_eventos
      SET g_entidade_id = g_predios.g_entidade_id
      FROM g_predios
      WHERE g_predios.id = m_eventos.g_predio_id
    SQL

    execute <<~SQL
      UPDATE m_musicas
      SET g_entidade_id = m_eventos.g_entidade_id
      FROM m_eventos_musicas
      INNER JOIN m_eventos ON m_eventos.id = m_eventos_musicas.m_evento_id
      WHERE m_eventos_musicas.m_musica_id = m_musicas.id
    SQL

    execute <<~SQL
      UPDATE m_arranjos
      SET g_entidade_id = m_musicas.g_entidade_id
      FROM m_musicas
      WHERE m_musicas.id = m_arranjos.m_musica_id
    SQL

    execute <<~SQL
      UPDATE m_arranjos_instrumentos_naipes
      SET g_entidade_id = m_arranjos.g_entidade_id
      FROM m_arranjos
      WHERE m_arranjos.id = m_arranjos_instrumentos_naipes.m_arranjo_id
    SQL

    execute <<~SQL
      UPDATE m_eventos_musicas
      SET g_entidade_id = m_eventos.g_entidade_id
      FROM m_eventos
      WHERE m_eventos.id = m_eventos_musicas.m_evento_id
    SQL

    execute <<~SQL
      UPDATE m_grupos_instrumentos_naipes
      SET g_entidade_id = m_grupos.g_entidade_id
      FROM m_grupos
      WHERE m_grupos.id = m_grupos_instrumentos_naipes.m_grupo_id
    SQL

    execute <<~SQL
      UPDATE m_grupos_pessoas
      SET g_entidade_id = m_grupos.g_entidade_id
      FROM m_grupos
      WHERE m_grupos.id = m_grupos_pessoas.m_grupo_id
    SQL

    execute <<~SQL
      UPDATE m_pessoas_funcoes
      SET g_entidade_id = g_pessoas.g_entidade_id
      FROM g_pessoas
      WHERE g_pessoas.id = m_pessoas_funcoes.g_pessoa_id
    SQL

    TABLES.each do |table|
      change_column_null table, :g_entidade_id, false
    end
  end

  def down
    TABLES.each do |table|
      remove_reference table, :g_entidade, foreign_key: true
    end
  end
end
