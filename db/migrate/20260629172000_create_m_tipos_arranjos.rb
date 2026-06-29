class CreateMTiposArranjos < ActiveRecord::Migration[8.1]
  def change
    create_table :m_tipos_arranjos do |t|
      t.string :descricao, null: false
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :m_tipos_arranjos, :deleted_at

    reversible do |dir|
      dir.up do
        Rake::Task["m_tipos_arranjos:populate"].reenable
        Rake::Task["m_tipos_arranjos:populate"].invoke
      end
    end
  end
end
