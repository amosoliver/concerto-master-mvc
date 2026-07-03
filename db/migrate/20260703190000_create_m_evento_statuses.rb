class CreateMEventoStatuses < ActiveRecord::Migration[8.1]
  def up
    create_table :m_evento_statuses do |t|
      t.string :codigo, null: false
      t.string :descricao, null: false
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :m_evento_statuses, :codigo, unique: true
    add_index :m_evento_statuses, :deleted_at

    Rake::Task["m_evento_statuses:populate"].reenable
    Rake::Task["m_evento_statuses:populate"].invoke

    add_reference :m_eventos, :m_evento_status, foreign_key: true

    execute <<~SQL.squish
      UPDATE m_eventos
      SET m_evento_status_id = m_evento_statuses.id
      FROM m_evento_statuses
      WHERE m_evento_statuses.codigo = COALESCE(NULLIF(m_eventos.status, ''), 'agendado')
    SQL

    agendado_id = select_value("SELECT id FROM m_evento_statuses WHERE codigo = 'agendado' LIMIT 1")
    change_column_null :m_eventos, :m_evento_status_id, false, agendado_id

    remove_column :m_eventos, :status, :string
  end

  def down
    add_column :m_eventos, :status, :string, null: false, default: "agendado"

    execute <<~SQL.squish
      UPDATE m_eventos
      SET status = m_evento_statuses.codigo
      FROM m_evento_statuses
      WHERE m_evento_statuses.id = m_eventos.m_evento_status_id
    SQL

    remove_reference :m_eventos, :m_evento_status, foreign_key: true
    drop_table :m_evento_statuses
  end
end
