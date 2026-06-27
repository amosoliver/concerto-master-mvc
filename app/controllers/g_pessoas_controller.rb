class GPessoasController < ApplicationController
  STEPS = %w[dados grupos instrumentos funcoes usuario].freeze

  before_action :set_g_pessoa, only: %i[show edit update destroy]
  before_action :prepare_new_wizard, only: %i[new create]
  before_action :prepare_edit_wizard, only: %i[edit update]
  before_action :load_form_collections, only: %i[new create edit update]
  helper_method :current_step, :step_index, :last_step?, :first_step?, :wizard_values, :step_path_for, :selected_entity

  def index
    @q = tenant_scope(GPessoa).ransack(params[:q])
    @g_pessoas = @q.result.order(created_at: :desc)
    @pagy, @g_pessoas = pagy(@g_pessoas, limit: 10)
  end

  def show
  end

  def new
    @g_pessoa = build_g_pessoa_from_wizard
  end

  def edit
    @g_pessoa = build_g_pessoa_from_wizard(@g_pessoa)
  end

  def create
    store_wizard_step!
    @g_pessoa = build_g_pessoa_from_wizard

    if navigating_previous?
      redirect_to new_g_pessoa_path(step: previous_step, resume: 1)
    elsif last_step?
      GPessoas::CreateService.new(g_pessoa: @g_pessoa, params: wizard_params).call
      clear_new_wizard!
      redirect_to g_pessoas_path, notice: "#{GPessoa.model_name.human} criado com sucesso."
    else
      redirect_to new_g_pessoa_path(step: next_step, resume: 1)
    end
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_entity
  end

  def update
    store_wizard_step!
    @g_pessoa = build_g_pessoa_from_wizard(@g_pessoa)

    if navigating_previous?
      redirect_to edit_g_pessoa_path(@g_pessoa, step: previous_step, resume: 1)
    elsif last_step?
      GPessoas::UpdateService.new(g_pessoa: @g_pessoa, params: wizard_params).call
      clear_edit_wizard!
      redirect_to g_pessoas_path, notice: "#{GPessoa.model_name.human} atualizado com sucesso."
    else
      redirect_to edit_g_pessoa_path(@g_pessoa, step: next_step, resume: 1)
    end
  rescue ActiveRecord::RecordInvalid
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @g_pessoa.discard
    redirect_to g_pessoas_path, notice: "#{GPessoa.model_name.human} removido com sucesso."
  end

  private

  def set_g_pessoa
    @g_pessoa = tenant_record!(GPessoa, params[:id])
  end

  def g_pessoa_params
    params.require(:g_pessoa).permit(
      :nome,
      :email,
      :cpf,
      :g_entidade_id,
      :g_sexo_id,
      :principal_u_funcao_id,
      :g_usuario_ativo,
      :g_usuario_password,
      :g_usuario_password_confirmation,
      g_instrumento_naipe_ids: [],
      u_funcao_ids: [],
      m_grupo_ids: [],
      u_perfil_ids: []
    )
  end

  def current_step
    step = params[:step].presence || STEPS.first
    STEPS.include?(step) ? step : STEPS.first
  end

  def step_index(step = current_step)
    STEPS.index(step) || 0
  end

  def next_step
    STEPS[[step_index + 1, STEPS.length - 1].min]
  end

  def previous_step
    STEPS[[step_index - 1, 0].max]
  end

  def last_step?
    current_step == STEPS.last
  end

  def first_step?
    current_step == STEPS.first
  end

  def wizard_values
    @wizard_values ||= persisted_wizard_values
  end

  def step_path_for(step)
    if action_name.in?(%w[edit update]) && @g_pessoa&.persisted?
      edit_g_pessoa_path(@g_pessoa, step: step, resume: 1)
    else
      new_g_pessoa_path(step: step, resume: 1)
    end
  end

  def store_wizard_step!
    session[wizard_session_key] = normalized_wizard_values(wizard_values.merge(g_pessoa_params.to_h))
  end

  def wizard_params
    wizard_values.deep_symbolize_keys
  end

  def persisted_wizard_values
    base_values = (session[wizard_session_key] || {}).deep_stringify_keys
    return normalized_wizard_values(base_values) unless @g_pessoa&.persisted?

    normalized_wizard_values({
      "nome" => @g_pessoa.nome,
      "email" => @g_pessoa.email,
      "cpf" => @g_pessoa.cpf,
      "g_entidade_id" => @g_pessoa.g_entidade_id,
      "g_sexo_id" => @g_pessoa.g_sexo_id,
      "g_instrumento_naipe_ids" => @g_pessoa.g_instrumento_naipe_ids,
      "u_funcao_ids" => @g_pessoa.u_funcao_ids,
      "principal_u_funcao_id" => @g_pessoa.principal_u_funcao_id,
      "m_grupo_ids" => @g_pessoa.m_grupo_ids,
      "g_usuario_ativo" => @g_pessoa.g_usuario_principal&.ativo ? "1" : "0",
      "u_perfil_ids" => @g_pessoa.g_usuario_principal&.u_perfil_ids || []
    }.merge(base_values))
  end

  def build_g_pessoa_from_wizard(record = GPessoa.new)
    values = wizard_params
    record.assign_attributes(
      nome: values[:nome],
      email: values[:email],
      cpf: values[:cpf],
      g_entidade_id: tenant_entity_id_for(values[:g_entidade_id]),
      g_sexo_id: values[:g_sexo_id]
    )
    record
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

  def wizard_session_key
    @wizard_session_key ||= @g_pessoa&.persisted? ? "g_pessoa_wizard_#{@g_pessoa.id}" : "g_pessoa_wizard_new"
  end

  def navigating_previous?
    params[:navigation] == "previous"
  end

  def fresh_wizard_start?
    action_name.in?(%w[new edit]) && params[:resume] != "1"
  end

  def load_form_collections
    @g_entidades = tenant_entity_scope
    @g_sexos = GSexo.order(:descricao)
    @m_grupos = selected_entity_id ? tenant_scope(MGrupo.includes(:g_instrumentos_naipes)).where(g_entidade_id: selected_entity_id).order(:descricao) : MGrupo.none
    @g_instrumentos_naipes =
      if @m_grupos.exists?
        GInstrumentoNaipe
          .joins(:m_grupos)
          .where(m_grupos: { id: @m_grupos.select(:id) })
          .distinct
          .includes(:g_instrumento, :g_naipe, :m_grupos)
          .sort_by(&:to_s)
      else
        []
      end
    @u_funcoes = UFuncao.order(:descricao)
    @u_perfis = UPerfil.order(:descricao)
  end

  def selected_entity_id
    @selected_entity_id ||= begin
      raw_id = wizard_values["g_entidade_id"].presence || @g_pessoa&.g_entidade_id
      tenant_entity_id_for(raw_id)
    end
  end

  def selected_entity
    return if selected_entity_id.blank?

    @selected_entity ||= tenant_entity_scope.find_by(id: selected_entity_id)
  end

  def normalized_wizard_values(values)
    normalized = values.deep_stringify_keys
    entity_id = tenant_entity_id_for(normalized["g_entidade_id"])
    normalized["g_entidade_id"] = entity_id

    valid_group_ids = if entity_id.present?
      tenant_scope(MGrupo).where(g_entidade_id: entity_id, id: Array(normalized["m_grupo_ids"])).pluck(:id)
    else
      []
    end
    normalized["m_grupo_ids"] = valid_group_ids

    valid_instrument_ids = if valid_group_ids.any?
      GInstrumentoNaipe
        .joins(:m_grupos)
        .where(m_grupos: { id: valid_group_ids })
        .where(id: Array(normalized["g_instrumento_naipe_ids"]))
        .distinct
        .pluck(:id)
    else
      []
    end
    normalized["g_instrumento_naipe_ids"] = valid_instrument_ids

    valid_funcao_ids = UFuncao.where(id: Array(normalized["u_funcao_ids"])).pluck(:id)
    normalized["u_funcao_ids"] = valid_funcao_ids

    normalized["principal_u_funcao_id"] =
      if valid_funcao_ids.include?(normalized["principal_u_funcao_id"].to_i)
        normalized["principal_u_funcao_id"].to_i
      end

    valid_perfil_ids = if valid_funcao_ids.any?
      UPerfil.joins(:u_funcoes).where(u_funcoes: { id: valid_funcao_ids }, id: Array(normalized["u_perfil_ids"])).distinct.pluck(:id)
    else
      []
    end
    normalized["u_perfil_ids"] = valid_perfil_ids

    normalized
  end
end
