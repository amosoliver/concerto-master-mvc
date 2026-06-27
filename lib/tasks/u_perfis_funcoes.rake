namespace :u_perfis_funcoes do
  desc "Vincula perfis a funções a partir de db/seeds/data/u_perfis_funcoes.yml"
  task populate: [ :environment, "u_perfis:populate", "u_funcoes:populate" ] do
    vinculos_data = YAML.load_file(Rails.root.join("db/seeds/data/u_perfis_funcoes.yml"))

    vinculos_data.each do |vinculo_data|
      perfil = UPerfil.find_by!(descricao: vinculo_data["perfil"])
      funcao_ids = Array(vinculo_data["funcoes"]).map do |funcao_descricao|
        UFuncao.find_by!(descricao: funcao_descricao).id
      end

      perfil.sync_u_funcoes!(funcao_ids)
      puts "✓ #{perfil.descricao}: #{funcao_ids.size} funções vinculadas."
    end

    puts "u_perfis_funcoes: #{UPerfilFuncao.count} registros."
  end
end
