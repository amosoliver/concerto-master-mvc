module GPessoas
  class BaseService
    attr_reader :g_pessoa, :params

    def initialize(g_pessoa:, params:)
      @g_pessoa = g_pessoa
      @params = params
    end

    private

    def assign_g_pessoa_attributes
      g_pessoa.assign_attributes(
        nome: params[:nome],
        email: params[:email],
        cpf: params[:cpf],
        g_entidade_id: params[:g_entidade_id],
        g_sexo_id: params[:g_sexo_id]
      )
    end

    def sync_relations!
      sync_g_pessoas_instrumentos!
      sync_m_pessoas_funcoes!
      sync_m_grupos_pessoas!
      sync_g_usuario!
    end

    def sync_g_pessoas_instrumentos!
      sync_join_records!(
        relation: g_pessoa.g_pessoas_instrumentos,
        join_model: GPessoasInstrumento,
        foreign_key: :g_instrumento_naipe_id,
        target_ids: params[:g_instrumento_naipe_ids]
      )
    end

    def sync_m_pessoas_funcoes!
      target_ids = normalize_ids(params[:u_funcao_ids])
      principal_id = params[:principal_u_funcao_id].presence&.to_i
      existing_records = MPessoaFuncao.with_discarded.where(g_pessoa_id: g_pessoa.id).index_by(&:u_funcao_id)

      target_ids.each do |u_funcao_id|
        record = existing_records[u_funcao_id] || MPessoaFuncao.new(g_pessoa_id: g_pessoa.id, u_funcao_id: u_funcao_id)
        record.deleted_at = nil
        record.principal = (principal_id == u_funcao_id)
        record.save! if record.changed?
      end

      existing_records.each do |u_funcao_id, record|
        if target_ids.include?(u_funcao_id)
          next if record.deleted_at.nil? && record.principal == (principal_id == u_funcao_id)

          record.update!(deleted_at: nil, principal: principal_id == u_funcao_id)
          next
        end

        next if record.deleted_at.present?

        record.update!(deleted_at: Time.current, principal: false)
      end
    end

    def sync_m_grupos_pessoas!
      sync_join_records!(
        relation: g_pessoa.m_grupos_pessoas,
        join_model: MGrupoPessoa,
        foreign_key: :m_grupo_id,
        target_ids: params[:m_grupo_ids]
      )
    end

    def sync_g_usuario!
      g_usuario = g_pessoa.g_usuarios.with_discarded.first_or_initialize
      g_usuario.g_pessoa = g_pessoa
      g_usuario.email = params[:email]
      g_usuario.ativo = true
      g_usuario.deleted_at = nil

      password = params[:g_usuario_password].presence || default_password
      password_confirmation = params[:g_usuario_password_confirmation].presence || password

      if g_usuario.new_record?
        g_usuario.password = password
        g_usuario.password_confirmation = password_confirmation
        g_usuario.primeiro_acesso = true
      elsif params[:g_usuario_password].present?
        g_usuario.password = params[:g_usuario_password]
        g_usuario.password_confirmation = params[:g_usuario_password_confirmation]
        g_usuario.primeiro_acesso = false
      end

      g_usuario.save!
      sync_u_usuarios_perfis!(g_usuario)
    end

    def sync_u_usuarios_perfis!(g_usuario)
      sync_join_records!(
        relation: g_usuario.u_usuarios_perfis,
        join_model: UUsuarioPerfil,
        foreign_key: :u_perfil_id,
        target_ids: params[:u_perfil_ids]
      )
    end

    def sync_join_records!(relation:, join_model:, foreign_key:, target_ids:)
      target_ids = normalize_ids(target_ids)
      existing_records = join_model.with_discarded.where(relation.scope_for_create).index_by(&foreign_key)

      target_ids.each do |target_id|
        record = existing_records[target_id] || relation.build(foreign_key => target_id)
        record.deleted_at = nil
        record.save! if record.changed?
      end

      existing_records.each do |target_id, record|
        next if target_ids.include?(target_id)
        next if record.deleted_at.present?

        record.update!(deleted_at: Time.current)
      end
    end

    def normalize_ids(values)
      Array(values).reject(&:blank?).map(&:to_i).uniq
    end

    def default_password
      "102030"
    end

    def merge_errors!(record)
      return if record == g_pessoa

      record.errors.full_messages.each do |message|
        g_pessoa.errors.add(:base, message)
      end
    end
  end
end
