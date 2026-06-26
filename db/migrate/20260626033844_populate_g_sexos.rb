class PopulateGSexos < ActiveRecord::Migration[8.1]
  def up
    say_with_time("Populando g_sexos") do
      Rake::Task["g_sexos:populate"].invoke
    end
  end

  def down
  end
end
