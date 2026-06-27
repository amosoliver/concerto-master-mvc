require "yaml"

class PopulatePermissionProfilesData < ActiveRecord::Migration[8.1]
  def up
    populate_perfis!
    populate_funcoes!
    populate_permissoes!
    sync_perfis_funcoes!
    sync_perfis_permissoes!
  end

  def down
    # Dados de perfis/permissões são mantidos; rollback estrutural não remove seed aplicada.
  end

  private

  def populate_perfis!
    return unless table_exists?(:u_perfis)

    load_yaml("u_perfis.yml").each do |perfil_data|
      UPerfil.find_or_create_by!(descricao: perfil_data.fetch("descricao"))
    end
  end

  def populate_funcoes!
    return unless table_exists?(:u_funcoes) && table_exists?(:u_tipos_funcoes)

    load_yaml("u_funcoes.yml").each do |funcao_data|
      tipo_funcao = UTipoFuncao.find_by!(descricao: funcao_data.fetch("tipo_funcao"))
      UFuncao.find_or_create_by!(descricao: funcao_data.fetch("descricao"), u_tipo_funcao: tipo_funcao)
    end
  end

  def populate_permissoes!
    return unless table_exists?(:u_permissoes)

    UPermissoesSyncService.call
  end

  def sync_perfis_funcoes!
    return unless table_exists?(:u_perfis_funcoes)

    load_yaml("u_perfis_funcoes.yml").each do |vinculo_data|
      perfil = UPerfil.find_by!(descricao: vinculo_data.fetch("perfil"))
      funcao_ids = Array(vinculo_data["funcoes"]).map do |funcao_descricao|
        UFuncao.find_by!(descricao: funcao_descricao).id
      end

      perfil.sync_u_funcoes!(funcao_ids)
    end
  end

  def sync_perfis_permissoes!
    return unless table_exists?(:u_perfis_permissoes)

    load_yaml("u_perfis_permissoes.yml").each do |vinculo_data|
      perfil = UPerfil.find_by!(descricao: vinculo_data.fetch("perfil"))
      permissao_ids = Array(vinculo_data["permissoes"]).map do |identificador|
        controlador, acao = identificador.split("#", 2)
        UPermissao.find_by!(controlador: controlador, acao: acao).id
      end

      perfil.sync_u_permissoes!(permissao_ids)
    end
  end

  def load_yaml(file_name)
    YAML.load_file(Rails.root.join("db/seeds/data", file_name))
  end
end
