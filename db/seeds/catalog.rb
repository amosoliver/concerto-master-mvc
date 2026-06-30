require "yaml"

module Seeds
  module Catalog
    DATA_DIR = Rails.root.join("db/seeds/data")

    def self.populate!
      seed_sexos
      seed_instrumentos_naipes
      seed_tonalidades
      seed_tipos_arranjos
      seed_tipos_grupos
      seed_funcoes
      seed_perfis
      seed_permissoes
      seed_concert_master!
    end

    def self.seed_sexos
      YAML.load_file(DATA_DIR.join("g_sexos.yml")).each do |d|
        GSexo.find_or_create_by!(descricao: d["descricao"])
      end
    end

    def self.seed_instrumentos_naipes
      YAML.load_file(DATA_DIR.join("g_instrumentos_naipes.yml")).each do |item|
        instrumento = GInstrumento.find_or_create_by!(descricao: item["instrumento"])
        item["naipes"].each do |naipe_descricao|
          naipe = GNaipe.find_or_create_by!(descricao: naipe_descricao)
          GInstrumentoNaipe.find_or_create_by!(g_instrumento: instrumento, g_naipe: naipe)
        end
      end
    end

    def self.seed_tonalidades
      YAML.load_file(DATA_DIR.join("m_tonalidades.yml")).each do |d|
        descricao = d["descricao"].to_s.strip
        next if descricao.blank?
        MTonalidade.find_or_create_by!(descricao: descricao)
      end
    end

    def self.seed_tipos_arranjos
      YAML.load_file(DATA_DIR.join("m_tipos_arranjos.yml")).each do |d|
        MTipoArranjo.find_or_create_by!(descricao: d["descricao"].to_s.upcase)
      end
    end

    def self.seed_tipos_grupos
      ["Coral", "Banda", "Orquestra", "Grupo de Louvor"].each do |d|
        MTipoGrupo.find_or_create_by!(descricao: d)
      end
    end

    def self.seed_funcoes
      musical = UTipoFuncao.find_or_create_by!(descricao: "Musical")
      ["Líder", "Instrumentista"].each do |d|
        UFuncao.find_or_create_by!(descricao: d, u_tipo_funcao: musical)
      end
    end

    def self.seed_perfis
      ["Administrador", "Líder", "Instrumentista"].each do |d|
        UPerfil.find_or_create_by!(descricao: d)
      end
    end

    def self.seed_permissoes
      SincronizadorPermissoesService.call

      lider_perfil          = UPerfil.find_by!(descricao: "Líder")
      instrumentista_perfil = UPerfil.find_by!(descricao: "Instrumentista")

      lider_perfil.sync_u_funcoes!([UFuncao.find_by!(descricao: "Líder").id])
      instrumentista_perfil.sync_u_funcoes!([UFuncao.find_by!(descricao: "Instrumentista").id])

      UPerfil.find_by!(descricao: "Administrador")
             .sync_u_permissoes!(UPermissao.pluck(:id))

      lider_controllers = %w[
        g_entidades g_instrumentos_naipes g_pessoas g_predios g_sexos g_usuarios
        m_arranjos m_ensaios m_eventos m_grupos m_musicas
        u_perfis u_permissoes home g_usuarios/sessions g_usuarios/registrations
      ]
      lider_perfil.sync_u_permissoes!(
        UPermissao.where(controlador: lider_controllers).pluck(:id)
      )

      instrumentista_ids =
        UPermissao.where(
          controlador: %w[m_eventos m_musicas m_arranjos g_instrumentos_naipes],
          acao: %w[index show manage manage_arranjos manage_files]
        ).pluck(:id) +
        UPermissao.where(
          controlador: %w[home g_usuarios/sessions g_usuarios/registrations]
        ).pluck(:id)
      instrumentista_perfil.sync_u_permissoes!(instrumentista_ids.uniq)
    end

    def self.seed_concert_master!
      estado, municipio = bootstrap_location
      unless estado && municipio
        puts "Bootstrap Concert Master ignorado: cadastre estados e municípios primeiro."
        return
      end

      administrador_perfil = UPerfil.find_by!(descricao: "Administrador")
      sexo = GSexo.find_by(descricao: "Masculino") || GSexo.first

      entidade = GEntidade.with_discarded.find_or_initialize_by(descricao: "Concert Master")
      entidade.assign_attributes(
        g_estado: estado,
        g_municipio: municipio,
        g_entidade_id: nil,
        deleted_at: nil
      )
      entidade.save!

      pessoa = GPessoa.with_discarded.find_or_initialize_by(cpf: "12345678901")
      pessoa.assign_attributes(
        nome: "Administrador Concert Master",
        email: "admin@concertmaster.local",
        g_entidade: entidade,
        g_sexo: sexo,
        deleted_at: nil
      )
      pessoa.save!

      usuario = GUsuario.with_discarded.find_or_initialize_by(g_pessoa: pessoa)
      usuario.assign_attributes(
        email: pessoa.email,
        ativo: true,
        primeiro_acesso: false,
        deleted_at: nil
      )
      usuario.password = "102030"
      usuario.password_confirmation = "102030"
      usuario.save!

      vinculo = UUsuarioPerfil.with_discarded.find_or_initialize_by(
        g_usuario: usuario,
        u_perfil: administrador_perfil
      )
      vinculo.deleted_at = nil
      vinculo.save! if vinculo.changed?

      puts "Bootstrap Concert Master concluído: entidade suprema e usuário administrador garantidos."
    end

    def self.bootstrap_location
      estado = GEstado.find_by(sigla: "RO") || GEstado.order(:descricao).first
      return [nil, nil] unless estado

      municipio = estado.g_municipios.find_by(descricao: "Porto Velho") || estado.g_municipios.order(:descricao).first
      [estado, municipio]
    end
  end
end
