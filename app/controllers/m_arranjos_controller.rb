class MArranjosController < ApplicationController
  before_action :set_m_arranjo, only: %i[show edit update destroy]

  def index
    @q = MArranjo.ransack(params[:q])
    @m_arranjos = @q.result.order(created_at: :desc)
    @pagy, @m_arranjos = pagy(@m_arranjos, limit: 10)
  end

  def show
  end

  def new
    @m_arranjo = MArranjo.new
  end

  def edit
  end

  def create
    @m_arranjo = MArranjo.new(m_arranjo_params)

    if @m_arranjo.save
      redirect_to @m_arranjo, notice: "M arranjo criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @m_arranjo.update(m_arranjo_params)
      redirect_to @m_arranjo, notice: "M arranjo atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @m_arranjo.discard
    redirect_to m_arranjos_path, notice: "M arranjo removido com sucesso."
  end

  private

  def set_m_arranjo
    @m_arranjo = MArranjo.find(params[:id])
  end

  def m_arranjo_params
    params.require(:m_arranjo).permit(:m_musica_id, :m_arranjador_id, :m_tonalidade_id)
  end
end
