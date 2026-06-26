namespace :u_tipos_funcoes do
  desc "Popula u_tipos_funcoes a partir de db/seeds/data/u_tipos_funcoes.yml"
  task populate: :environment do
    tipos_data = YAML.load_file(Rails.root.join("db/seeds/data/u_tipos_funcoes.yml"))

    tipos_data.each do |tipo_data|
      tipo_funcao = UTipoFuncao.find_or_create_by!(descricao: tipo_data["descricao"])
      puts "✓ Tipo de função: #{tipo_funcao.descricao}"
    end

    puts "u_tipos_funcoes: #{UTipoFuncao.count} registros."
  end
end
