class GPrediosController < ApplicationController
  before_action :set_g_predio, only: %i[show edit update destroy]

  def index
    @q = GPredio.ransack(params[:q])
    @g_predios = @q.result.order(created_at: :desc)
    @pagy, @g_predios = pagy(@g_predios, limit: 10)
  end

  def show
  end

  def new
    @g_predio = GPredio.new
  end

  def edit
  end

  def create
    @g_predio = GPredio.new(g_predio_params)

    if @g_predio.save
      redirect_to @g_predio, notice: "G predio criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @g_predio.update(g_predio_params)
      redirect_to @g_predio, notice: "G predio atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @g_predio.discard
    redirect_to g_predios_path, notice: "G predio removido com sucesso."
  end

  private

  def set_g_predio
    @g_predio = GPredio.find(params[:id])
  end

  def g_predio_params
    params.require(:g_predio).permit(:nome_fantasia, :cep, :logradouro, :bairro, :g_entidade_id)
  end
end
