class PopulateGMunicipios < ActiveRecord::Migration[8.1]
  def up
    say_with_time("Populando g_municipios a partir da API do IBGE") do
      Rake::Task["g_municipios:populate"].invoke
    end
  end

  def down
  end
end
