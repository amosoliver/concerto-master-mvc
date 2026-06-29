class TenantScopeResolver
  INSTRUMENT_SCOPED_MODELS = %w[
    GPessoasInstrumento
    MGrupoInstrumentoNaipe
    MGrupoPessoa
    MArranjoInstrumentoNaipe
    MPessoaFuncao
    MEventoMusica
  ].freeze

  def self.call(scope:, entity_ids:, instrument_ids:)
    new(scope: scope, entity_ids: entity_ids, instrument_ids: instrument_ids).call
  end

  def initialize(scope:, entity_ids:, instrument_ids:)
    @scope = normalize_scope(scope)
    @entity_ids = Array(entity_ids).map(&:to_i).uniq
    @instrument_ids = Array(instrument_ids).map(&:to_i).uniq
  end

  def call
    return scope.none if entity_ids.empty?

    scoped = apply_entity_scope(scope)
    apply_instrument_scope(scoped)
  end

  private

  attr_reader :scope, :entity_ids, :instrument_ids

  def model_name
    scope.klass.name
  end

  def normalize_scope(scope)
    scope.respond_to?(:klass) ? scope : scope.all
  end

  def apply_entity_scope(relation)
    case model_name
    when "GEntidade"
      relation.where(id: entity_ids)
    when "GUsuario"
      relation.joins(:g_pessoa).where(g_pessoas: { g_entidade_id: entity_ids }).distinct
    when "GPredio", "GPessoa", "MGrupo", "GPessoasInstrumento", "MMusica",
         "MArranjo", "MArranjoInstrumentoNaipe", "MEvento", "MEventoMusica",
         "MGrupoInstrumentoNaipe", "MGrupoPessoa", "MPessoaFuncao"
      relation.where(g_entidade_id: entity_ids)
    else
      relation
    end
  end

  def apply_instrument_scope(relation)
    return relation unless INSTRUMENT_SCOPED_MODELS.include?(model_name)
    return relation.none if instrument_ids.empty?

    case model_name
    when "GPessoasInstrumento", "MGrupoInstrumentoNaipe", "MArranjoInstrumentoNaipe"
      relation.where(g_instrumento_naipe_id: instrument_ids)
    when "MGrupoPessoa", "MPessoaFuncao"
      relation.joins(g_pessoa: :g_pessoas_instrumentos).where(g_pessoas_instrumentos: { g_instrumento_naipe_id: instrument_ids }).distinct
    when "MMusica"
      relation.joins(m_arranjos: :m_arranjos_instrumentos_naipes).where(m_arranjos_instrumentos_naipes: { g_instrumento_naipe_id: instrument_ids }).distinct
    when "MArranjo"
      relation.joins(:m_arranjos_instrumentos_naipes).where(m_arranjos_instrumentos_naipes: { g_instrumento_naipe_id: instrument_ids }).distinct
    when "MEventoMusica"
      relation.joins(m_musica: { m_arranjos: :m_arranjos_instrumentos_naipes }).where(m_arranjos_instrumentos_naipes: { g_instrumento_naipe_id: instrument_ids }).distinct
    else
      relation
    end
  end
end
