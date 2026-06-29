namespace :db do
  desc "Executa todas as tasks de população inicial de dados, na ordem correta"
  task populate_all: :environment do
    %w[
      g_paises:populate
      g_estados:populate
      g_municipios:populate
      g_sexos:populate
      g_instrumentos:populate
      g_naipes:populate
      g_instrumentos_naipes:populate
      m_tonalidades:populate
      m_tipos_arranjos:populate
      u_tipos_funcoes:populate
      u_funcoes:populate
      u_perfis:populate
      u_permissoes:populate
      u_perfis_funcoes:populate
      u_perfis_permissoes:populate
    ].each do |task_name|
      puts "👉 Executando rake #{task_name}..."
      Rake::Task[task_name].invoke
    end

    puts "✅ Todas as tasks de população foram executadas com sucesso!"
  end
end
