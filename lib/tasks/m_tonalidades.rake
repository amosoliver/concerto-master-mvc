namespace :m_tonalidades do
  desc "Popula m_tonalidades a partir de db/seeds/data/m_tonalidades.yml"
  task populate: :environment do
    tonalidades_data = YAML.load_file(Rails.root.join("db/seeds/data/m_tonalidades.yml"))

    tonalidades_data.each do |tonalidade_data|
      descricao = tonalidade_data["descricao"].to_s.strip
      next if descricao.blank?

      tonalidade = MTonalidade.find_or_create_by!(descricao: descricao)
      puts "✓ Tonalidade: #{tonalidade.descricao}"
    end

    puts "m_tonalidades: #{MTonalidade.count} registros."
  end
end
