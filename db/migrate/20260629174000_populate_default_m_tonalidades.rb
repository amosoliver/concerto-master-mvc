class PopulateDefaultMTonalidades < ActiveRecord::Migration[8.1]
  def up
    Rake::Task["m_tonalidades:populate"].reenable
    Rake::Task["m_tonalidades:populate"].invoke
  end

  def down
  end
end
