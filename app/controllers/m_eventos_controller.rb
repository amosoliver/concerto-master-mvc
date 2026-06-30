class MEventosController < ApplicationController
  STEPS = %w[dados repertorio revisao].freeze

  before_action :set_m_evento, only: %i[show edit update destroy manage update_management]
  before_action :load_form_collections, only: %i[new create edit update manage update_management]
  before_action :load_management_collections, only: %i[show manage update_management]
  before_action :prepare_new_wizard, only: %i[new create]
  before_action :prepare_edit_wizard, only: %i[edit update]
  helper_method :current_step, :first_step?, :last_step?, :step_path_for

  def index
    @q = tenant_scope(MEvento).ransack(params[:q])
    @m_eventos = @q.result.includes(:g_predio, m_eventos_musicas: { m_musica: :m_artista }).order(created_at: :desc)
    @pagy, @m_eventos = pagy(@m_eventos, limit: 10)
  end

  def show
  end

  def new
    @m_evento = MEvento.new
    apply_wizard_values
    preload_form_state
  end

  def edit
    apply_wizard_values
    preload_form_state
  end

  def manage
  end

  def create
    store_wizard_step!
    @m_evento = MEvento.new
    apply_wizard_values
    preload_form_state

    if navigating_previous?
      redirect_to new_m_evento_path(step: previous_step, resume: 1)
    elsif last_step?
      MEventos::ServicoCriacao.new(m_evento: @m_evento, params: wizard_params).call
      clear_new_wizard!
      redirect_to m_evento_path(@m_evento), notice: "#{MEvento.model_name.human} criado com sucesso."
    else
      redirect_to new_m_evento_path(step: next_step, resume: 1)
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
      redirect_to edit_m_evento_path(@m_evento, step: previous_step, resume: 1)
    elsif last_step?
      MEventos::ServicoAtualizacao.new(m_evento: @m_evento, params: wizard_params).call
      clear_edit_wizard!
      redirect_to m_evento_path(@m_evento), notice: "#{MEvento.model_name.human} atualizado com sucesso."
    else
      redirect_to edit_m_evento_path(@m_evento, step: next_step, resume: 1)
    end
  rescue ActiveRecord::RecordInvalid
    apply_wizard_values
    preload_form_state
    render :edit, status: :unprocessable_entity
  end

  def update_management
    if MEventos::ServicoAtualizacao.new(m_evento: @m_evento, params: m_evento_management_params).call
      redirect_to manage_m_evento_path(@m_evento), notice: "Configurações do evento atualizadas com sucesso."
    end
  rescue ActiveRecord::RecordInvalid
    render :manage, status: :unprocessable_entity
  end

  def destroy
    @m_evento.discard
    redirect_to m_eventos_path, notice: "#{MEvento.model_name.human} removido com sucesso."
  end

  private

  def set_m_evento
    @m_evento = tenant_record!(MEvento, params[:id])
  end

  def m_evento_params
    params.fetch(:m_evento, {}).permit(
      :descricao,
      :data_inicio,
      :data_fim,
      :g_predio_id,
      :novo_g_predio_nome_fantasia,
      :novo_g_predio_cep,
      :novo_g_predio_logradouro,
      :novo_g_predio_bairro,
      :novo_g_predio_latitude,
      :novo_g_predio_longitude,
      repertorio: [:selecionada, :m_musica_id, :m_arranjo_id, { m_grupo_ids: [] }]
    )
  end

  def m_evento_management_params
    permitted = m_evento_params.to_h.deep_symbolize_keys
    permitted[:descricao] = permitted[:descricao].presence || @m_evento.descricao
    permitted[:data_inicio] = permitted[:data_inicio].presence || @m_evento.data_inicio
    permitted[:data_fim] = permitted[:data_fim].presence || @m_evento.data_fim
    permitted[:g_predio_id] = permitted[:g_predio_id].presence || @m_evento.g_predio_id
    permitted
  end

  def load_form_collections
    @g_predios = tenant_predio_scope
    @m_grupos = tenant_grupo_scope.includes(:m_tipo_grupo).order(:descricao)
    @m_musicas = tenant_scope(MMusica.includes(:m_artista, :m_compositor)).order(:descricao)
    @arranjos_por_musica = tenant_scope(MArranjo.includes(:m_tipo_arranjo, :m_arranjador, :m_tonalidade)).order(:descricao).group_by(&:m_musica_id)
  end

  def load_management_collections
    @evento_repertorio = @m_evento.m_eventos_musicas
                                .includes(
                                  :m_grupos,
                                  m_musica: %i[m_artista m_compositor],
                                  m_arranjo: [
                                    :m_tipo_arranjo,
                                    :m_arranjador,
                                    :m_tonalidade,
                                    { audio_attachments: :blob },
                                    { m_arranjos_instrumentos_naipes: [:g_instrumento_naipe, { arquivo_attachments: :blob }] }
                                  ]
                                )
                                .sort_by { |evento_musica| evento_musica.m_musica.descricao.to_s }
    @ensaios_relacionados = @m_evento.m_ensaios.includes(:g_predio, :m_musicas, :m_grupos).order(:data_inicio)

    preload_form_state if action_name.in?(%w[manage update_management])
  end

  def preload_form_state
    selected_rows = if wizard_params[:repertorio].present?
      repertorio_entries_from(wizard_params[:repertorio]).filter_map do |entry|
        next unless ActiveModel::Type::Boolean.new.cast(entry[:selecionada])

        musica_id = entry[:m_musica_id].presence&.to_i
        next if musica_id.blank?

        {
          m_musica_id: musica_id,
          m_arranjo_id: entry[:m_arranjo_id].presence&.to_i,
          m_grupo_ids: Array(entry[:m_grupo_ids]).reject(&:blank?).map(&:to_i)
        }
      end
    elsif @m_evento.persisted?
      @m_evento.m_eventos_musicas.order(:id).map do |evento_musica|
        {
          m_musica_id: evento_musica.m_musica_id,
          m_arranjo_id: evento_musica.m_arranjo_id,
          m_grupo_ids: evento_musica.m_grupos.ids
        }
      end
    else
      []
    end

    @selected_repertorio = selected_rows.index_by { |entry| entry[:m_musica_id] }
  end

  def repertorio_entries_from(value)
    case value
    when ActionController::Parameters
      repertorio_entries_from(value.to_unsafe_h)
    when Hash
      value.values
    else
      Array(value)
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

  def step_path_for(step)
    if @m_evento&.persisted?
      edit_m_evento_path(@m_evento, step: step, resume: 1)
    else
      new_m_evento_path(step: step, resume: 1)
    end
  end

  def wizard_session_key
    @wizard_session_key ||= @m_evento&.persisted? ? "m_evento_wizard_#{@m_evento.id}" : "m_evento_wizard_new"
  end

  def wizard_params
    (session[wizard_session_key] || {}).deep_symbolize_keys
  end

  def store_wizard_step!
    session[wizard_session_key] = wizard_params.deep_stringify_keys.merge(m_evento_params.to_h)
  end

  def prepare_new_wizard
    clear_new_wizard! if params[:reset] == "1" || fresh_wizard_start?
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

  def fresh_wizard_start?
    action_name.in?(%w[new edit]) && params[:resume] != "1"
  end

  def apply_wizard_values
    return unless defined?(@m_evento) && @m_evento

    @m_evento.assign_attributes(
      descricao: wizard_params.fetch(:descricao, @m_evento.descricao),
      data_inicio: wizard_params.fetch(:data_inicio, @m_evento.data_inicio),
      data_fim: wizard_params.fetch(:data_fim, @m_evento.data_fim),
      g_predio_id: wizard_params.fetch(:g_predio_id, @m_evento.g_predio_id)
    )

    @m_evento.novo_g_predio_nome_fantasia = wizard_params.fetch(:novo_g_predio_nome_fantasia, @m_evento.novo_g_predio_nome_fantasia)
    @m_evento.novo_g_predio_cep = wizard_params.fetch(:novo_g_predio_cep, @m_evento.novo_g_predio_cep)
    @m_evento.novo_g_predio_logradouro = wizard_params.fetch(:novo_g_predio_logradouro, @m_evento.novo_g_predio_logradouro)
    @m_evento.novo_g_predio_bairro = wizard_params.fetch(:novo_g_predio_bairro, @m_evento.novo_g_predio_bairro)
    @m_evento.novo_g_predio_latitude = wizard_params.fetch(:novo_g_predio_latitude, @m_evento.novo_g_predio_latitude)
    @m_evento.novo_g_predio_longitude = wizard_params.fetch(:novo_g_predio_longitude, @m_evento.novo_g_predio_longitude)
  end
end
