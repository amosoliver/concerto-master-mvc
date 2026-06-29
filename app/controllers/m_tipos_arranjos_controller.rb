class MTiposArranjosController < ApplicationController
  before_action :set_m_tipo_arranjo, only: %i[show edit update destroy]

  def index
    @q = MTipoArranjo.ransack(params[:q])
    @m_tipos_arranjos = @q.result.order(created_at: :desc)
    @pagy, @m_tipos_arranjos = pagy(@m_tipos_arranjos, limit: 10)
  end

  def show
  end

  def new
    @m_tipo_arranjo = MTipoArranjo.new
  end

  def edit
  end

  def create
    @m_tipo_arranjo = MTipoArranjo.new(m_tipo_arranjo_params)

    if @m_tipo_arranjo.save
      redirect_to m_tipos_arranjos_path, notice: "#{MTipoArranjo.model_name.human} criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @m_tipo_arranjo.update(m_tipo_arranjo_params)
      redirect_to m_tipos_arranjos_path, notice: "#{MTipoArranjo.model_name.human} atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @m_tipo_arranjo.discard
    redirect_to m_tipos_arranjos_path, notice: "#{MTipoArranjo.model_name.human} removido com sucesso."
  end

  private

  def set_m_tipo_arranjo
    @m_tipo_arranjo = MTipoArranjo.find(params[:id])
  end

  def m_tipo_arranjo_params
    params.require(:m_tipo_arranjo).permit(:descricao)
  end
end
