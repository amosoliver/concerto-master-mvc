class MEnsaiosController < ApplicationController
  STEPS = %w[dados grupos_eventos repertorio revisao].freeze

  layout "modal", only: %i[new edit create update]

  before_action :set_m_ensaio, only: %i[show edit update destroy]
  before_action :prepare_new_wizard, only: %i[new create]
  before_action :prepare_edit_wizard, only: %i[edit update]
  before_action :load_form_collections, only: %i[new create edit update]
  helper_method :current_step, :first_step?, :last_step?

  def index
    @q = tenant_scope(MEnsaio).ransack(params[:q])
    @m_ensaios = @q.result.includes(:g_predio, :m_eventos, m_ensaio_musicas: { m_evento_musica: :m_musica }).order(created_at: :desc)
    @pagy, @m_ensaios = pagy(@m_ensaios, limit: 5)
  end

  def show
  end

  def new
    @m_ensaio = MEnsaio.new
    apply_wizard_values
    preload_form_state
  end

  def edit
    apply_wizard_values
    preload_form_state
  end

  def create
    store_wizard_step!
    @m_ensaio = MEnsaio.new
    apply_wizard_values
    preload_form_state

    if navigating_previous?
      redirect_to new_m_ensaio_path(step: previous_step, resume: 1)
    elsif navigation_target_step
      redirect_to new_m_ensaio_path(step: navigation_target_step, resume: 1)
    elsif last_step?
      MEnsaios::ServicoCriacao.new(m_ensaio: @m_ensaio, params: wizard_params).call
      clear_new_wizard!
      redirect_to m_ensaio_path(@m_ensaio), notice: "#{MEnsaio.model_name.human} criado com sucesso."
    else
      redirect_to new_m_ensaio_path(step: next_step, resume: 1)
    end
  rescue ActiveRecord::RecordInvalid
    apply_wizard_values
    preload_form_state
    render :new, status: :unprocessable_entity
  end

  def update
    store_wizard_step!
    apply_wizard_values
    preload_form_state

    if navigating_previous?
      redirect_to edit_m_ensaio_path(@m_ensaio, step: previous_step, resume: 1)
    elsif navigation_target_step
      redirect_to edit_m_ensaio_path(@m_ensaio, step: navigation_target_step, resume: 1)
    elsif last_step?
      MEnsaios::ServicoAtualizacao.new(m_ensaio: @m_ensaio, params: wizard_params).call
      clear_edit_wizard!
      redirect_to m_ensaio_path(@m_ensaio), notice: "#{MEnsaio.model_name.human} atualizado com sucesso."
    else
      redirect_to edit_m_ensaio_path(@m_ensaio, step: next_step, resume: 1)
    end
  rescue ActiveRecord::RecordInvalid
    apply_wizard_values
    preload_form_state
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @m_ensaio.discard
    redirect_to m_ensaios_path, notice: "#{MEnsaio.model_name.human} removido com sucesso."
  end

  private

  def set_m_ensaio
    @m_ensaio = tenant_record!(MEnsaio, params[:id])
  end

  def m_ensaio_params
    params.fetch(:m_ensaio, ActionController::Parameters.new).permit(
      :descricao,
      :data_inicio,
      :data_fim,
      :g_predio_id,
      m_grupo_ids: [],
      m_evento_ids: [],
      repertorio: %i[selecionada m_evento_musica_id observacao]
    )
  end

  def load_form_collections
    @g_predios = tenant_predio_scope
    @grupos_disponiveis = tenant_grupo_scope.includes(:m_tipo_grupo)
    @eventos_disponiveis = tenant_scope(MEvento.includes(:g_predio, m_eventos_musicas: %i[m_musica m_arranjo])).order(:data_inicio)
    @evento_musicas_disponiveis = @eventos_disponiveis.flat_map(&:m_eventos_musicas).sort_by do |evento_musica|
      [evento_musica.m_evento&.data_inicio || Time.zone.at(0), evento_musica.m_musica&.descricao.to_s]
    end
  end

  def current_step
    step = params[:step].presence || STEPS.first
    STEPS.include?(step) ? step : STEPS.first
  end

  def first_step?
    current_step == STEPS.first
  end

  def last_step?
    current_step == STEPS.last
  end

  def next_step
    STEPS[[STEPS.index(current_step) + 1, STEPS.length - 1].min]
  end

  def previous_step
    STEPS[[STEPS.index(current_step) - 1, 0].max]
  end

  def wizard_session_key
    @wizard_session_key ||= @m_ensaio&.persisted? ? "m_ensaio_wizard_#{@m_ensaio.id}" : "m_ensaio_wizard_new"
  end

  def wizard_params
    (session[wizard_session_key] || {}).deep_symbolize_keys
  end

  def store_wizard_step!
    session[wizard_session_key] = wizard_params.deep_stringify_keys.merge(m_ensaio_params.to_h)
  end

  def prepare_new_wizard
    clear_new_wizard! if params[:reset] == "1" || fresh_wizard_start?
    seed_wizard_event_from_query!
  end

  # O atalho "Cadastrar ensaio para este evento" chega como ?m_evento_id=X só
  # na primeira requisição (GET /new). Sem gravar isso na sessão do wizard já
  # de cara, o evento marcado se perde assim que o usuário avança da etapa
  # "dados" (que não reenvia m_evento_ids) para a etapa "grupos_eventos".
  def seed_wizard_event_from_query!
    return if params[:m_evento_id].blank?
    return if wizard_params.key?(:m_evento_ids)

    session[wizard_session_key] = wizard_params.deep_stringify_keys.merge("m_evento_ids" => [params[:m_evento_id].to_s])
  end

  def prepare_edit_wizard
    clear_edit_wizard! if params[:reset] == "1" || fresh_wizard_start?
  end

  def clear_new_wizard!
    session.delete(wizard_session_key)
  end

  def clear_edit_wizard!
    session.delete(wizard_session_key)
  end

  def navigating_previous?
    params[:navigation] == "previous"
  end

  def navigation_target_step
    value = params[:navigation].to_s
    return unless value.start_with?("goto:")

    step = value.delete_prefix("goto:")
    step if STEPS.include?(step)
  end

  def fresh_wizard_start?
    action_name.in?(%w[new edit]) && params[:resume] != "1"
  end

  def apply_wizard_values
    return unless @m_ensaio

    @m_ensaio.assign_attributes(
      descricao: wizard_params.fetch(:descricao, @m_ensaio.descricao),
      data_inicio: wizard_params.fetch(:data_inicio, @m_ensaio.data_inicio),
      data_fim: wizard_params.fetch(:data_fim, @m_ensaio.data_fim),
      g_predio_id: wizard_params.fetch(:g_predio_id, @m_ensaio.g_predio_id)
    )
  end

  def preload_form_state
    @selected_group_ids = if wizard_params.key?(:m_grupo_ids)
      normalize_ids(wizard_params[:m_grupo_ids])
    elsif @m_ensaio.persisted?
      existing_group_ids
    else
      []
    end

    @selected_event_ids = if wizard_params.key?(:m_evento_ids)
      normalize_ids(wizard_params[:m_evento_ids])
    elsif @m_ensaio.persisted?
      existing_event_ids
    else
      selected_event_ids_from_query
    end

    @selected_repertorio = if wizard_params.key?(:repertorio)
      repertorio_from_wizard_params
    elsif @m_ensaio.persisted?
      existing_repertorio
    elsif @selected_event_ids.any?
      repertorio_from_selected_events
    else
      {}
    end
  end

  def repertorio_from_wizard_params
    entries = wizard_params[:repertorio]
    return {} if entries.blank?

    entries.values.filter_map do |entry|
      next unless ActiveModel::Type::Boolean.new.cast(entry[:selecionada])

      evento_musica_id = entry[:m_evento_musica_id].presence&.to_i
      next if evento_musica_id.blank?

      {
        m_evento_musica_id: evento_musica_id,
        selecionada: true,
        observacao: entry[:observacao].to_s
      }
    end.index_by { |entry| entry[:m_evento_musica_id] }
  end

  def selected_event_ids_from_query
    values = Array(params[:m_evento_ids]) + Array(params[:m_evento_id])
    normalize_ids(values)
  end

  def existing_event_ids
    @m_ensaio.m_eventos.ids
  end

  def existing_group_ids
    @m_ensaio.m_grupos.ids
  end

  def existing_repertorio
    @m_ensaio.m_ensaio_musicas.each_with_object({}) do |ensaio_musica, memo|
      memo[ensaio_musica.m_evento_musica_id] = {
        m_evento_musica_id: ensaio_musica.m_evento_musica_id,
        selecionada: true,
        observacao: ensaio_musica.observacao.to_s
      }
    end
  end

  def repertorio_from_selected_events
    @evento_musicas_disponiveis.each_with_object({}) do |evento_musica, memo|
      next unless @selected_event_ids.include?(evento_musica.m_evento_id)

      memo[evento_musica.id] = {
        m_evento_musica_id: evento_musica.id,
        selecionada: true,
        observacao: ""
      }
    end
  end

  def normalize_ids(values)
    Array(values).reject(&:blank?).map(&:to_i).uniq
  end
end
