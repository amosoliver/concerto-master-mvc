namespace :g_sexos do
  desc "Popula g_sexos a partir de db/seeds/data/g_sexos.yml"
  task populate: :environment do
    sexos_data = YAML.load_file(Rails.root.join("db/seeds/data/g_sexos.yml"))

    sexos_data.each do |sexo_data|
      sexo = GSexo.find_or_create_by!(descricao: sexo_data["descricao"])
      puts "✓ Sexo: #{sexo.descricao}"
    end

    puts "g_sexos: #{GSexo.count} registros."
  end
end
