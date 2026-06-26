require "net/http"
require "json"

namespace :g_estados do
  desc "Popula g_estados com os estados do Brasil cadastrados na API do IBGE"
  task populate: [ :environment, "g_paises:populate" ] do
    brasil = GPais.find_by!(descricao: "Brasil")

    uri = URI("https://servicodados.ibge.gov.br/api/v1/localidades/estados?orderBy=nome")
    estados_data = JSON.parse(Net::HTTP.get(uri))

    estados_data.each do |estado_data|
      estado = GEstado.find_or_initialize_by(codigo_ibge: estado_data["id"].to_s)
      estado.assign_attributes(
        descricao: estado_data["nome"],
        sigla: estado_data["sigla"],
        g_pais: brasil
      )
      estado.save!
      puts "✓ Estado: #{estado.descricao} (#{estado.sigla})"
    rescue => e
      puts "  ⚠️  Erro ao salvar estado #{estado_data['nome']}: #{e.message}"
    end

    puts "g_estados: #{GEstado.count} registros."
  end
end
