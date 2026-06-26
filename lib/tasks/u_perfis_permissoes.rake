namespace :u_perfis_permissoes do
  desc "Vincula o perfil Administrador a todas as permissões existentes"
  task populate: [ :environment, "u_perfis:populate" ] do
    UPermissoesSyncService.call

    perfil = UPerfil.find_by!(descricao: "Administrador")

    UPermissao.find_each do |permissao|
      UPerfilPermissao.find_or_create_by!(u_perfil: perfil, u_permissao: permissao)
    end

    puts "✓ #{perfil.descricao}: #{perfil.u_permissoes.count} permissões vinculadas."
  end
end
