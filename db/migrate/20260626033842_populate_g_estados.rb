class PopulateGEstados < ActiveRecord::Migration[8.1]
  def up
    say_with_time("Populando g_estados a partir da API do IBGE") do
      Rake::Task["g_estados:populate"].invoke
    end
  end

  def down
  end
end
