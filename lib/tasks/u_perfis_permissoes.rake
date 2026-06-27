namespace :u_perfis_permissoes do
  desc "Vincula perfis às permissões a partir de db/seeds/data/u_perfis_permissoes.yml"
  task populate: [ :environment, "u_perfis:populate", "u_permissoes:populate" ] do
    vinculos_data = YAML.load_file(Rails.root.join("db/seeds/data/u_perfis_permissoes.yml"))

    vinculos_data.each do |vinculo_data|
      perfil = UPerfil.find_by!(descricao: vinculo_data["perfil"])
      permissao_ids = Array(vinculo_data["permissoes"]).map do |identificador|
        controlador, acao = identificador.split("#", 2)
        UPermissao.find_by!(controlador: controlador, acao: acao).id
      end

      perfil.sync_u_permissoes!(permissao_ids)
      puts "✓ #{perfil.descricao}: #{permissao_ids.size} permissões vinculadas."
    end
  end
end
