class GPaisesController < ApplicationController
  before_action :set_g_pais, only: %i[show edit update destroy]

  def index
    @q = GPais.ransack(params[:q])
    @g_paises = @q.result.order(created_at: :desc)
    @pagy, @g_paises = pagy(@g_paises, limit: 10)
  end

  def show
  end

  def new
    @g_pais = GPais.new
  end

  def edit
  end

  def create
    @g_pais = GPais.new(g_pais_params)

    if @g_pais.save
      redirect_to @g_pais, notice: "#{GPais.model_name.human} criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @g_pais.update(g_pais_params)
      redirect_to @g_pais, notice: "#{GPais.model_name.human} atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @g_pais.discard
    redirect_to g_paises_path, notice: "#{GPais.model_name.human} removido com sucesso."
  end

  private

  def set_g_pais
    @g_pais = GPais.find(params[:id])
  end

  def g_pais_params
    params.require(:g_pais).permit(:descricao)
  end
end
