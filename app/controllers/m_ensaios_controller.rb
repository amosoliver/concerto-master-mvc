class MEnsaiosController < ApplicationController
  before_action :set_m_ensaio, only: %i[show edit update destroy]
  before_action :load_form_collections, only: %i[new create edit update]
  before_action :prepare_form_state, only: %i[new create edit update]

  def index
    @q = tenant_scope(MEnsaio).ransack(params[:q])
    @m_ensaios = @q.result.includes(:g_predio, :m_eventos, m_ensaio_musicas: { m_evento_musica: :m_musica }).order(created_at: :desc)
    @pagy, @m_ensaios = pagy(@m_ensaios, limit: 10)
  end

  def show
  end

  def new
    @m_ensaio = MEnsaio.new
    apply_form_defaults
  end

  def edit
    apply_form_defaults
  end

  def create
    @m_ensaio = MEnsaio.new
    apply_form_defaults

    if MEnsaios::ServicoCriacao.new(m_ensaio: @m_ensaio, params: m_ensaio_params.to_h.deep_symbolize_keys).call
      redirect_to m_ensaios_path, notice: "#{MEnsaio.model_name.human} criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid
    apply_form_defaults
    render :new, status: :unprocessable_entity
  end

  def update
    apply_form_defaults

    if MEnsaios::ServicoAtualizacao.new(m_ensaio: @m_ensaio, params: m_ensaio_params.to_h.deep_symbolize_keys).call
      redirect_to m_ensaios_path, notice: "#{MEnsaio.model_name.human} atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid
    apply_form_defaults
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

  def prepare_form_state
    @selected_group_ids = selected_group_ids_from_params
    @selected_event_ids = selected_event_ids_from_params
    @selected_repertorio = selected_repertorio_from_params
  end

  def apply_form_defaults
    @selected_group_ids = existing_group_ids if @selected_group_ids.empty? && @m_ensaio.persisted?
    @selected_event_ids = existing_event_ids if @selected_event_ids.empty? && @m_ensaio.persisted?
    @selected_repertorio = existing_repertorio if @selected_repertorio.empty? && @m_ensaio.persisted?
    @selected_event_ids = selected_event_ids_from_query if @selected_event_ids.empty?
    @selected_repertorio = repertorio_from_selected_events if @selected_repertorio.empty? && @selected_event_ids.any?
    @m_ensaio.assign_attributes(m_ensaio_params.except(:m_evento_ids, :repertorio)) if params[:m_ensaio].present?
  end

  def selected_event_ids_from_query
    values = Array(params[:m_evento_ids]) + Array(params[:m_evento_id])
    normalize_ids(values)
  end

  def selected_group_ids_from_params
    normalize_ids(m_ensaio_params[:m_grupo_ids])
  end

  def selected_event_ids_from_params
    normalize_ids(m_ensaio_params[:m_evento_ids])
  end

  def selected_repertorio_from_params
    repertorio = m_ensaio_params[:repertorio]
    entries = case repertorio
    when ActionController::Parameters
      repertorio.to_unsafe_h.values
    when Hash
      repertorio.values
    else
      Array(repertorio)
    end

    entries.filter_map do |entry|
      evento_musica_id = entry[:m_evento_musica_id].presence&.to_i
      next if evento_musica_id.blank?

      {
        m_evento_musica_id: evento_musica_id,
        selecionada: ActiveModel::Type::Boolean.new.cast(entry[:selecionada]),
        observacao: entry[:observacao].to_s
      }
    end.index_by { |entry| entry[:m_evento_musica_id] }
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
