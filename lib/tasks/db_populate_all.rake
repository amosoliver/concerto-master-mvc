namespace :db do
  desc "Cria/atualiza a entidade suprema Concert Master e o usuário administrador padrão"
  task bootstrap_concert_master: :environment do
    require Rails.root.join("db/seeds/catalog")

    puts "==> Bootstrap Concert Master"
    Seeds::Catalog.seed_concert_master!
  end

  desc "Popula catálogo + permissões + geodados (IBGE) + bootstrap Concert Master. Use populate_geo para geodados apenas."
  task populate_all: :environment do
    puts "==> Geodados via IBGE (pode demorar alguns minutos)"
    Rake::Task["db:populate_geo"].invoke

    puts "==> Catálogo e permissões"
    Rails.application.load_seed

    Rake::Task["db:bootstrap_concert_master"].invoke

    puts "Concluído!"
  end

  desc "Popula apenas os geodados (países, estados, municípios) via API do IBGE"
  task populate_geo: :environment do
    Rake::Task["g_paises:populate"].invoke
    Rake::Task["g_estados:populate"].invoke
    Rake::Task["g_municipios:populate"].invoke
  end
end

Rake::Task["db:migrate"].enhance do
  if ENV["SKIP_POST_MIGRATE_POPULATE"] == "1"
    puts "==> Carga automática pós-migrate ignorada por SKIP_POST_MIGRATE_POPULATE=1"
    next
  end

  puts "==> Executando carga automática após db:migrate"
  Rake::Task["db:populate_all"].invoke
end
