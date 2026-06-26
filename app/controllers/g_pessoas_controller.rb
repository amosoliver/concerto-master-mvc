class GPessoasController < ApplicationController
  STEPS = %w[dados grupos instrumentos funcoes usuario].freeze

  before_action :set_g_pessoa, only: %i[show edit update destroy]
  before_action :load_form_collections, only: %i[new create edit update]
  before_action :prepare_new_wizard, only: %i[new create]
  before_action :prepare_edit_wizard, only: %i[edit update]
  helper_method :current_step, :step_index, :last_step?, :first_step?, :wizard_values, :step_path_for

  def index
    @q = GPessoa.ransack(params[:q])
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
      redirect_to new_g_pessoa_path(step: previous_step)
    elsif last_step?
      GPessoas::CreateService.new(g_pessoa: @g_pessoa, params: wizard_params).call
      clear_new_wizard!
      redirect_to g_pessoas_path, notice: "#{GPessoa.model_name.human} criado com sucesso."
    else
      redirect_to new_g_pessoa_path(step: next_step)
    end
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_entity
  end

  def update
    store_wizard_step!
    @g_pessoa = build_g_pessoa_from_wizard(@g_pessoa)

    if navigating_previous?
      redirect_to edit_g_pessoa_path(@g_pessoa, step: previous_step)
    elsif last_step?
      GPessoas::UpdateService.new(g_pessoa: @g_pessoa, params: wizard_params).call
      clear_edit_wizard!
      redirect_to g_pessoas_path, notice: "#{GPessoa.model_name.human} atualizado com sucesso."
    else
      redirect_to edit_g_pessoa_path(@g_pessoa, step: next_step)
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
    @g_pessoa = GPessoa.find(params[:id])
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
      edit_g_pessoa_path(@g_pessoa, step: step)
    else
      new_g_pessoa_path(step: step)
    end
  end

  def store_wizard_step!
    session[wizard_session_key] = wizard_values.merge(g_pessoa_params.to_h)
  end

  def wizard_params
    wizard_values.deep_symbolize_keys
  end

  def persisted_wizard_values
    base_values = session[wizard_session_key] || {}
    return base_values unless @g_pessoa&.persisted?

    {
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
    }.merge(base_values)
  end

  def build_g_pessoa_from_wizard(record = GPessoa.new)
    values = wizard_params
    record.assign_attributes(
      nome: values[:nome],
      email: values[:email],
      cpf: values[:cpf],
      g_entidade_id: values[:g_entidade_id],
      g_sexo_id: values[:g_sexo_id]
    )
    record
  end

  def prepare_new_wizard
    clear_new_wizard! if params[:reset] == "1"
  end

  def prepare_edit_wizard
    clear_edit_wizard! if params[:reset] == "1"
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

  def load_form_collections
    @g_entidades = GEntidade.order(:descricao)
    @g_sexos = GSexo.order(:descricao)
    @g_instrumentos_naipes = GInstrumentoNaipe.includes(:g_instrumento, :g_naipe, :m_grupos).sort_by(&:to_s)
    @u_funcoes = UFuncao.order(:descricao)
    @m_grupos = MGrupo.includes(:g_instrumentos_naipes).order(:descricao)
    @u_perfis = UPerfil.order(:descricao)
  end
end
