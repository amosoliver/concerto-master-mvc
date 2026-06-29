class CreateMTonalidades < ActiveRecord::Migration[8.1]
  def change
    create_table :m_tonalidades do |t|
      t.string :descricao
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :m_tonalidades, :deleted_at

    reversible do |dir|
      dir.up do
        Rake::Task["m_tonalidades:populate"].reenable
        Rake::Task["m_tonalidades:populate"].invoke
      end
    end
  end
end
