class PopulateGInstrumentos < ActiveRecord::Migration[8.1]
  def up
    say_with_time("Populando g_instrumentos") do
      Rake::Task["g_instrumentos:populate"].invoke
    end
  end

  def down
  end
end
