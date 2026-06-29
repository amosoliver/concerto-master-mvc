class AddUrlReferenciaToMMusicas < ActiveRecord::Migration[8.1]
  def change
    add_column :m_musicas, :url_referencia, :string
  end
end
