class AddDescricaoToMArranjos < ActiveRecord::Migration[8.1]
  def change
    add_column :m_arranjos, :descricao, :string

    reversible do |dir|
      dir.up do
        execute <<~SQL.squish
          UPDATE m_arranjos
          SET descricao = CONCAT('ARRANJO ', id)
          WHERE descricao IS NULL
        SQL
      end
    end
  end
end
