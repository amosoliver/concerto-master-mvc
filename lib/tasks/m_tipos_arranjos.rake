namespace :m_tipos_arranjos do
  desc "Popula m_tipos_arranjos a partir de db/seeds/data/m_tipos_arranjos.yml"
  task populate: :environment do
    tipos_data = YAML.load_file(Rails.root.join("db/seeds/data/m_tipos_arranjos.yml"))

    tipos_data.each do |tipo_data|
      tipo = MTipoArranjo.find_or_create_by!(descricao: tipo_data["descricao"].to_s.upcase)
      puts "✓ Tipo de arranjo: #{tipo.descricao}"
    end

    puts "m_tipos_arranjos: #{MTipoArranjo.count} registros."
  end
end
