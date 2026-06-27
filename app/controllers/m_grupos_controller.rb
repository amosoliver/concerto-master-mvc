class MGruposController < ApplicationController
  before_action :set_m_grupo, only: %i[show edit update destroy]

  def index
    @q = tenant_scope(MGrupo).ransack(params[:q])
    @m_grupos = @q.result.order(created_at: :desc)
    @pagy, @m_grupos = pagy(@m_grupos, limit: 10)
  end

  def show
  end

  def new
    @m_grupo = MGrupo.new
  end

  def edit
  end

  def create
    @m_grupo = MGrupo.new(m_grupo_params.merge(g_entidade_id: tenant_entity_id_for(m_grupo_params[:g_entidade_id])))

    if @m_grupo.save
      redirect_to @m_grupo, notice: "#{MGrupo.model_name.human} criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @m_grupo.update(m_grupo_params)
      redirect_to @m_grupo, notice: "#{MGrupo.model_name.human} atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
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
    params.require(:m_grupo).permit(:descricao, :g_entidade_id, :m_tipo_grupo_id)
  end
end
