require "net/http"
require "json"

namespace :g_paises do
  desc "Popula g_paises com os países cadastrados na API de localidades do IBGE"
  task populate: :environment do
    uri = URI("https://servicodados.ibge.gov.br/api/v1/localidades/paises?orderBy=nome")
    paises_data = JSON.parse(Net::HTTP.get(uri))

    paises_data.each do |pais_data|
      pais = GPais.find_or_create_by!(descricao: pais_data["nome"])
      puts "✓ País: #{pais.descricao}"
    rescue => e
      puts "  ⚠️  Erro ao salvar país #{pais_data['nome']}: #{e.message}"
    end

    puts "g_paises: #{GPais.count} registros."
  end
end
