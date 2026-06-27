class GEntidadesController < ApplicationController
  STEPS = %w[dados predio grupos].freeze

  before_action :set_g_entidade, only: %i[show edit update destroy]
  before_action :prepare_new_wizard, only: %i[new create]
  before_action :prepare_edit_wizard, only: %i[edit update]
  before_action :load_form_collections, only: %i[new create edit update]
  before_action :load_group_rows, only: %i[new create edit update]
  helper_method :current_step, :first_step?, :last_step?, :step_path_for

  def index
    @q = tenant_scope(GEntidade).ransack(params[:q])
    @g_entidades = @q.result.order(created_at: :desc)
    @pagy, @g_entidades = pagy(@g_entidades, limit: 10)
  end

  def show
  end

  def new
    @g_entidade = GEntidade.new
    apply_wizard_values
  end

  def edit
    apply_wizard_values
  end

  def create
    store_wizard_step!
    @g_entidade = GEntidade.new(wizard_params.except(:grupos_attributes))
    apply_wizard_values

    if navigating_previous?
      redirect_to new_g_entidade_path(step: previous_step, resume: 1)
    elsif last_step?
      GEntidades::CreateService.new(g_entidade: @g_entidade, params: wizard_params).call
      clear_new_wizard!
      redirect_to g_entidades_path, notice: "#{GEntidade.model_name.human} criado com sucesso."
    else
      redirect_to new_g_entidade_path(step: next_step, resume: 1)
    end
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_entity
  end

  def update
    store_wizard_step!
    apply_wizard_values

    if navigating_previous?
      redirect_to edit_g_entidade_path(@g_entidade, step: previous_step, resume: 1)
    elsif last_step?
      GEntidades::UpdateService.new(g_entidade: @g_entidade, params: wizard_params).call
      clear_edit_wizard!
      redirect_to g_entidades_path, notice: "#{GEntidade.model_name.human} atualizado com sucesso."
    else
      redirect_to edit_g_entidade_path(@g_entidade, step: next_step, resume: 1)
    end
  rescue ActiveRecord::RecordInvalid
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @g_entidade.discard
    redirect_to g_entidades_path, notice: "#{GEntidade.model_name.human} removido com sucesso."
  end

  private

  def set_g_entidade
    @g_entidade = tenant_record!(GEntidade, params[:id])
  end

  def g_entidade_params
    params.require(:g_entidade).permit(
      :descricao,
      :g_estado_id,
      :g_municipio_id,
      :g_entidade_id,
      predio_attributes: %i[nome_fantasia cep logradouro bairro],
      grupos_attributes: [
        :id,
        :descricao,
        :m_tipo_grupo_id,
        :_destroy,
        { g_instrumento_naipe_ids: [] }
      ]
    )
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
    if @g_entidade&.persisted?
      edit_g_entidade_path(@g_entidade, step: step, resume: 1)
    else
      new_g_entidade_path(step: step, resume: 1)
    end
  end

  def wizard_session_key
    @wizard_session_key ||= @g_entidade&.persisted? ? "g_entidade_wizard_#{@g_entidade.id}" : "g_entidade_wizard_new"
  end

  def wizard_params
    (session[wizard_session_key] || {}).deep_symbolize_keys
  end

  def store_wizard_step!
    session[wizard_session_key] = wizard_params.deep_stringify_keys.merge(g_entidade_params.to_h)
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

  def load_form_collections
    @g_estados = GEstado.order(:descricao)
    @g_municipios = GMunicipio.order(:descricao)
    @g_entidades_pai = @g_entidade&.persisted? ? tenant_entity_scope.where.not(id: @g_entidade.id) : tenant_entity_scope
    @m_tipos_grupos = MTipoGrupo.order(:descricao)
    @g_instrumentos_naipes = tenant_instrumento_scope.sort_by(&:to_s)
    @g_predio ||= @g_entidade&.g_predio_principal || GPredio.new
  end

  def load_group_rows
    @group_rows =
      if params[:g_entidade].present? && params[:g_entidade][:grupos_attributes].present?
        params[:g_entidade][:grupos_attributes].to_unsafe_h.values
      elsif wizard_params[:grupos_attributes].present?
        wizard_params[:grupos_attributes].to_h.values
      elsif @g_entidade&.persisted?
        @g_entidade.m_grupos.with_discarded.includes(:g_instrumentos_naipes).map do |group|
          {
            id: group.id,
            descricao: group.descricao,
            m_tipo_grupo_id: group.m_tipo_grupo_id,
            g_instrumento_naipe_ids: group.g_instrumento_naipe_ids
          }
        end
      else
        []
      end

    @group_rows = [{ descricao: nil, m_tipo_grupo_id: nil, g_instrumento_naipe_ids: [] }] if @group_rows.empty?

    apply_wizard_values
  end

  def apply_wizard_values
    return unless defined?(@g_entidade) && @g_entidade

    # Usa fetch com o valor atual como default: uma etapa ainda não visitada
    # não envia sua chave no wizard_params, então não deve apagar o que já
    # está salvo no registro (ver g_estado/g_municipio "required" ao navegar
    # direto para a etapa de Grupos).
    @g_entidade.assign_attributes(
      descricao: wizard_params.fetch(:descricao, @g_entidade.descricao),
      g_estado_id: wizard_params.fetch(:g_estado_id, @g_entidade.g_estado_id),
      g_municipio_id: wizard_params.fetch(:g_municipio_id, @g_entidade.g_municipio_id),
      g_entidade_id: wizard_params.fetch(:g_entidade_id, @g_entidade.g_entidade_id)
    )

    @g_predio ||= @g_entidade.g_predio_principal || @g_entidade.g_predios.build
    predio_attrs = wizard_params[:predio_attributes]
    @g_predio.assign_attributes(predio_attrs.slice(:nome_fantasia, :cep, :logradouro, :bairro)) if predio_attrs.present?
  end
end
