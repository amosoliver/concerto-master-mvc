class PopulateGPaises < ActiveRecord::Migration[8.1]
  def up
    say_with_time("Populando g_paises a partir da API do IBGE") do
      Rake::Task["g_paises:populate"].invoke
    end
  end

  def down
  end
end
