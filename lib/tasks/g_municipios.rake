require "net/http"
require "json"

namespace :g_municipios do
  desc "Popula g_municipios com os municípios cadastrados na API do IBGE, por estado"
  task populate: [ :environment, "g_estados:populate" ] do
    GEstado.find_each do |estado|
      uri = URI("https://servicodados.ibge.gov.br/api/v1/localidades/estados/#{estado.codigo_ibge}/municipios")
      municipios_data = JSON.parse(Net::HTTP.get(uri))

      municipios_data.each do |municipio_data|
        municipio = GMunicipio.find_or_initialize_by(codigo_ibge: municipio_data["id"].to_s)
        municipio.assign_attributes(descricao: municipio_data["nome"], g_estado: estado)
        municipio.save!
      rescue => e
        puts "  ⚠️  Erro ao salvar município #{municipio_data['nome']}: #{e.message}"
      end

      puts "✓ #{estado.sigla}: #{municipios_data.size} municípios processados."
    rescue => e
      puts "  ⚠️  Erro ao buscar municípios de #{estado.sigla}: #{e.message}"
    end

    puts "g_municipios: #{GMunicipio.count} registros."
  end
end
