namespace :g_naipes do
  desc "Popula g_naipes a partir de db/seeds/data/g_instrumentos_naipes.yml"
  task populate: :environment do
    dados = YAML.load_file(Rails.root.join("db/seeds/data/g_instrumentos_naipes.yml"))
    naipes = dados.flat_map { |item| item["naipes"] }.uniq

    naipes.each do |descricao|
      naipe = GNaipe.find_or_create_by!(descricao: descricao)
      puts "✓ Naipe: #{naipe.descricao}"
    end

    puts "g_naipes: #{GNaipe.count} registros."
  end
end
