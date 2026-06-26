namespace :u_funcoes do
  desc "Popula u_funcoes a partir de db/seeds/data/u_funcoes.yml"
  task populate: [ :environment, "u_tipos_funcoes:populate" ] do
    funcoes_data = YAML.load_file(Rails.root.join("db/seeds/data/u_funcoes.yml"))

    funcoes_data.each do |funcao_data|
      tipo_funcao = UTipoFuncao.find_by!(descricao: funcao_data["tipo_funcao"])
      funcao = UFuncao.find_or_create_by!(descricao: funcao_data["descricao"], u_tipo_funcao: tipo_funcao)
      puts "✓ Função: #{funcao.descricao}"
    end

    puts "u_funcoes: #{UFuncao.count} registros."
  end
end
