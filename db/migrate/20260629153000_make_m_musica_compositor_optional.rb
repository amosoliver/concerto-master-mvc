class MakeMMusicaCompositorOptional < ActiveRecord::Migration[8.1]
  def change
    change_column_null :m_musicas, :m_compositor_id, true
  end
end
