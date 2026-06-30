class AddMArranjoToMEventosMusicas < ActiveRecord::Migration[8.0]
  def change
    add_reference :m_eventos_musicas, :m_arranjo, null: true, foreign_key: true
  end
end
