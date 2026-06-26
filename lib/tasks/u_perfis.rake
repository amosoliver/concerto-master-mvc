namespace :u_perfis do
  desc "Popula u_perfis a partir de db/seeds/data/u_perfis.yml"
  task populate: :environment do
    perfis_data = YAML.load_file(Rails.root.join("db/seeds/data/u_perfis.yml"))

    perfis_data.each do |perfil_data|
      perfil = UPerfil.find_or_create_by!(descricao: perfil_data["descricao"])
      puts "✓ Perfil: #{perfil.descricao}"
    end

    puts "u_perfis: #{UPerfil.count} registros."
  end
end
