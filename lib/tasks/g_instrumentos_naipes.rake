namespace :g_instrumentos_naipes do
  desc "Vincula instrumentos aos seus naipes a partir de db/seeds/data/g_instrumentos_naipes.yml"
  task populate: [ :environment, "g_instrumentos:populate", "g_naipes:populate" ] do
    dados = YAML.load_file(Rails.root.join("db/seeds/data/g_instrumentos_naipes.yml"))

    dados.each do |item|
      instrumento = GInstrumento.find_by!(descricao: item["instrumento"])

      item["naipes"].each do |naipe_descricao|
        naipe = GNaipe.find_by!(descricao: naipe_descricao)
        GInstrumentoNaipe.find_or_create_by!(g_instrumento: instrumento, g_naipe: naipe)
        puts "✓ #{instrumento.descricao} - #{naipe.descricao}"
      end
    end

    puts "g_instrumentos_naipes: #{GInstrumentoNaipe.count} registros."
  end
end
