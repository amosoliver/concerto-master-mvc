class GEstadosController < ApplicationController
  before_action :set_g_estado, only: %i[show edit update destroy]

  def index
    @q = GEstado.ransack(params[:q])
    @g_estados = @q.result.order(created_at: :desc)
    @pagy, @g_estados = pagy(@g_estados, limit: 10)
  end

  def show
  end

  def new
    @g_estado = GEstado.new
  end

  def edit
  end

  def create
    @g_estado = GEstado.new(g_estado_params)

    if @g_estado.save
      redirect_to g_estados_path, notice: "#{GEstado.model_name.human} criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @g_estado.update(g_estado_params)
      redirect_to g_estados_path, notice: "#{GEstado.model_name.human} atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @g_estado.discard
    redirect_to g_estados_path, notice: "#{GEstado.model_name.human} removido com sucesso."
  end

  private

  def set_g_estado
    @g_estado = GEstado.find(params[:id])
  end

  def g_estado_params
    params.require(:g_estado).permit(:descricao, :sigla, :codigo_ibge, :g_pais_id)
  end
end
