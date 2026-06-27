namespace :u_permissoes do
  desc "Sincroniza u_permissoes a partir das rotas da aplicação"
  task populate: :environment do
    total = UPermissoesSyncService.call
    puts "u_permissoes: #{UPermissao.count} registros."
    puts "✓ #{total} permissões criadas ou atualizadas."
  end
end
