namespace :g_instrumentos do
  desc "Popula g_instrumentos a partir de db/seeds/data/g_instrumentos_naipes.yml"
  task populate: :environment do
    dados = YAML.load_file(Rails.root.join("db/seeds/data/g_instrumentos_naipes.yml"))

    dados.each do |item|
      instrumento = GInstrumento.find_or_create_by!(descricao: item["instrumento"])
      puts "✓ Instrumento: #{instrumento.descricao}"
    end

    puts "g_instrumentos: #{GInstrumento.count} registros."
  end
end
