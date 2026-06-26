class MTonalidadesController < ApplicationController
  before_action :set_m_tonalidade, only: %i[show edit update destroy]

  def index
    @q = MTonalidade.ransack(params[:q])
    @m_tonalidades = @q.result.order(created_at: :desc)
    @pagy, @m_tonalidades = pagy(@m_tonalidades, limit: 10)
  end

  def show
  end

  def new
    @m_tonalidade = MTonalidade.new
  end

  def edit
  end

  def create
    @m_tonalidade = MTonalidade.new(m_tonalidade_params)

    if @m_tonalidade.save
      redirect_to @m_tonalidade, notice: "#{MTonalidade.model_name.human} criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @m_tonalidade.update(m_tonalidade_params)
      redirect_to @m_tonalidade, notice: "#{MTonalidade.model_name.human} atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @m_tonalidade.discard
    redirect_to m_tonalidades_path, notice: "#{MTonalidade.model_name.human} removido com sucesso."
  end

  private

  def set_m_tonalidade
    @m_tonalidade = MTonalidade.find(params[:id])
  end

  def m_tonalidade_params
    params.require(:m_tonalidade).permit(:descricao)
  end
end
