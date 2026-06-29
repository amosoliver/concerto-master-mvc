class PopulateDefaultMTiposArranjos < ActiveRecord::Migration[8.1]
  def up
    Rake::Task["m_tipos_arranjos:populate"].reenable
    Rake::Task["m_tipos_arranjos:populate"].invoke
  end

  def down
  end
end
