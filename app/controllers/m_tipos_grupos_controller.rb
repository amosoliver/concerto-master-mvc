class MTiposGruposController < ApplicationController
  before_action :set_m_tipo_grupo, only: %i[show edit update destroy]

  def index
    @q = MTipoGrupo.ransack(params[:q])
    @m_tipos_grupos = @q.result.order(created_at: :desc)
    @pagy, @m_tipos_grupos = pagy(@m_tipos_grupos, limit: 10)
  end

  def show
  end

  def new
    @m_tipo_grupo = MTipoGrupo.new
  end

  def edit
  end

  def create
    @m_tipo_grupo = MTipoGrupo.new(m_tipo_grupo_params)

    if @m_tipo_grupo.save
      redirect_to @m_tipo_grupo, notice: "M tipo grupo criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @m_tipo_grupo.update(m_tipo_grupo_params)
      redirect_to @m_tipo_grupo, notice: "M tipo grupo atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @m_tipo_grupo.discard
    redirect_to m_tipos_grupos_path, notice: "M tipo grupo removido com sucesso."
  end

  private

  def set_m_tipo_grupo
    @m_tipo_grupo = MTipoGrupo.find(params[:id])
  end

  def m_tipo_grupo_params
    params.require(:m_tipo_grupo).permit(:descricao)
  end
end
