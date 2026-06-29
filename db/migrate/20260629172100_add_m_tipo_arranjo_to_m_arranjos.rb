class AddMTipoArranjoToMArranjos < ActiveRecord::Migration[8.1]
  def change
    add_reference :m_arranjos, :m_tipo_arranjo, foreign_key: { to_table: :m_tipos_arranjos }
  end
end
