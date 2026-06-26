namespace :u_perfis_funcoes do
  desc "Vincula perfis a funções a partir de db/seeds/data/u_perfis_funcoes.yml"
  task populate: [ :environment, "u_perfis:populate", "u_funcoes:populate" ] do
    vinculos_data = YAML.load_file(Rails.root.join("db/seeds/data/u_perfis_funcoes.yml"))

    vinculos_data.each do |vinculo_data|
      perfil = UPerfil.find_by!(descricao: vinculo_data["perfil"])
      funcao = UFuncao.find_by!(descricao: vinculo_data["funcao"])
      UPerfilFuncao.find_or_create_by!(u_perfil: perfil, u_funcao: funcao)
      puts "✓ #{perfil.descricao} - #{funcao.descricao}"
    end

    puts "u_perfis_funcoes: #{UPerfilFuncao.count} registros."
  end
end
