class PopulateGNaipes < ActiveRecord::Migration[8.1]
  def up
    say_with_time("Populando g_naipes") do
      Rake::Task["g_naipes:populate"].invoke
    end
  end

  def down
  end
end
