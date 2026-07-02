module TenantAccess
  extend ActiveSupport::Concern

  included do
    helper_method :current_tenant_entity,
                  :current_tenant_entity_ids,
                  :current_tenant_admin?,
                  :current_tenant_instrument_ids,
                  :tenant_entity_scope,
                  :tenant_pessoa_scope,
                  :tenant_grupo_scope,
                  :tenant_predio_scope,
                  :tenant_instrumento_scope,
                  :tenant_evento_scope,
                  :tenant_musica_scope,
                  :tenant_arranjo_scope
  end

  private

  def tenant_scope(scope)
    return normalize_tenant_scope(scope) if tenant_bypass_scope?(scope)

    ResolvedorEscopoEntidade.call(
      scope: normalize_tenant_scope(scope),
      entity_ids: current_tenant_entity_ids,
      instrument_ids: current_tenant_instrument_ids
    )
  end

  def tenant_record!(scope, id)
    tenant_scope(scope).find(id)
  end

  def tenant_entity_id_for(value = nil)
    entity_id = value.presence&.to_i
    return current_tenant_entity&.id if entity_id.blank?

    current_tenant_entity_ids.include?(entity_id) ? entity_id : current_tenant_entity&.id
  end

  def current_tenant_entity
    Current.g_entidade
  end

  def current_tenant_entity_ids
    Current.g_entidade_ids || []
  end

  def current_tenant_instrument_ids
    return all_instrument_ids_for_current_tenant if current_tenant_admin?

    Current.g_instrumento_naipe_ids || []
  end

  def current_tenant_admin?
    current_g_usuario&.admin_for?(current_tenant_entity)
  end

  def tenant_entity_scope
    GEntidade.where(id: current_tenant_entity_ids).order(:descricao)
  end

  def tenant_pessoa_scope
    tenant_scope(GPessoa.includes(:g_entidade)).order(:nome)
  end

  def tenant_grupo_scope
    tenant_scope(MGrupo.includes(:g_entidade)).order(:descricao)
  end

  def tenant_predio_scope
    tenant_scope(GPredio.includes(:g_entidade)).order(:nome_fantasia)
  end

  def tenant_instrumento_scope
    scope = GInstrumentoNaipe.includes(:g_instrumento, :g_naipe).order(:id)
    return scope if current_tenant_admin?

    current_tenant_instrument_ids.present? ? scope.where(id: current_tenant_instrument_ids) : scope.none
  end

  def tenant_evento_scope
    tenant_scope(MEvento.includes(:g_predio)).order(:descricao)
  end

  def tenant_musica_scope
    tenant_scope(MMusica.all).order(:descricao)
  end

  def tenant_arranjo_scope
    tenant_scope(MArranjo.includes(:m_musica)).order(:id)
  end

  def tenant_bypass_scope?(scope)
    return false unless current_tenant_admin?

    %w[MArranjo MArranjoInstrumentoNaipe].include?(normalize_tenant_scope(scope).klass.name)
  end

  def normalize_tenant_scope(scope)
    scope.respond_to?(:klass) ? scope : scope.all
  end

  def all_instrument_ids_for_current_tenant
    @all_instrument_ids_for_current_tenant ||= GInstrumentoNaipe.pluck(:id)
  end
end
