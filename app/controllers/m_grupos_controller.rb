class MGruposController < ApplicationController
  before_action :set_m_grupo, only: %i[show edit update destroy manage update_management]
  before_action :load_management_collections, only: %i[manage update_management]

  def index
    @q = tenant_scope(MGrupo).ransack(params[:q])
    @m_grupos = @q.result.order(created_at: :desc)
    @pagy, @m_grupos = pagy(@m_grupos, limit: 5)
  end

  def show
  end

  def new
    @m_grupo = MGrupo.new
  end

  def edit
  end

  def manage
  end

  def create
    @m_grupo = MGrupo.new(m_grupo_params)

    if @m_grupo.save
      redirect_to m_grupos_path, notice: "#{MGrupo.model_name.human} criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @m_grupo.update(m_grupo_params)
      redirect_to m_grupos_path, notice: "#{MGrupo.model_name.human} atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update_management
    ActiveRecord::Base.transaction do
      sync_group_people!
      sync_group_instrumentos!
    end

    redirect_to manage_m_grupo_path(@m_grupo), notice: "Configurações do grupo atualizadas com sucesso."
  end

  def destroy
    @m_grupo.discard
    redirect_to m_grupos_path, notice: "#{MGrupo.model_name.human} removido com sucesso."
  end

  private

  def set_m_grupo
    @m_grupo = tenant_record!(MGrupo, params[:id])
  end

  def m_grupo_params
    params.require(:m_grupo).permit(:descricao, :m_tipo_grupo_id)
  end

  def management_params
    params.fetch(:m_grupo, {}).permit(g_pessoa_ids: [], g_instrumento_naipe_ids: [])
  end

  def load_management_collections
    @available_pessoas = tenant_scope(GPessoa).where(g_entidade_id: @m_grupo.g_entidade_id).order(:nome)
    @available_instrumentos = GInstrumentoNaipe.includes(:g_instrumento, :g_naipe).sort_by(&:to_s)
  end

  def sync_group_people!
    selected_ids = @available_pessoas.where(id: Array(management_params[:g_pessoa_ids]).reject(&:blank?)).pluck(:id)
    existing_records = MGrupoPessoa.with_discarded.where(m_grupo: @m_grupo).index_by(&:g_pessoa_id)

    selected_ids.each do |pessoa_id|
      record = existing_records[pessoa_id]

      if record.present?
        record.undiscard if record.discarded?
      else
        MGrupoPessoa.create!(m_grupo: @m_grupo, g_pessoa_id: pessoa_id, g_entidade: @m_grupo.g_entidade)
      end
    end

    records_to_remove = MGrupoPessoa.where(m_grupo: @m_grupo, deleted_at: nil)
    records_to_remove = records_to_remove.where.not(g_pessoa_id: selected_ids) if selected_ids.any?
    records_to_remove.find_each(&:discard)
  end

  def sync_group_instrumentos!
    selected_ids = GInstrumentoNaipe.where(id: Array(management_params[:g_instrumento_naipe_ids]).reject(&:blank?)).pluck(:id)
    existing_records = MGrupoInstrumentoNaipe.with_discarded.where(m_grupo: @m_grupo).index_by(&:g_instrumento_naipe_id)

    selected_ids.each do |instrumento_id|
      record = existing_records[instrumento_id]

      if record.present?
        record.undiscard if record.discarded?
      else
        MGrupoInstrumentoNaipe.create!(m_grupo: @m_grupo, g_instrumento_naipe_id: instrumento_id, g_entidade: @m_grupo.g_entidade)
      end
    end

    records_to_remove = MGrupoInstrumentoNaipe.where(m_grupo: @m_grupo, deleted_at: nil)
    records_to_remove = records_to_remove.where.not(g_instrumento_naipe_id: selected_ids) if selected_ids.any?
    records_to_remove.find_each(&:discard)
  end
end
