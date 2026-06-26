class PopulateUPerfis < ActiveRecord::Migration[8.1]
  def up
    say_with_time("Populando u_perfis") do
      Rake::Task["u_perfis:populate"].invoke
    end
  end

  def down
  end
end
