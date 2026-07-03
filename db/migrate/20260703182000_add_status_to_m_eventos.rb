class AddStatusToMEventos < ActiveRecord::Migration[8.0]
  def change
    add_column :m_eventos, :status, :string, null: false, default: "agendado"
    add_column :m_eventos, :status_at, :datetime

    add_index :m_eventos, :status
  end
end
