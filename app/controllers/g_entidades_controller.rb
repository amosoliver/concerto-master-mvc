class GEntidadesController < ApplicationController
  before_action :set_g_entidade, only: %i[show edit update destroy]

  def index
    @q = GEntidade.ransack(params[:q])
    @g_entidades = @q.result.order(created_at: :desc)
    @pagy, @g_entidades = pagy(@g_entidades, limit: 10)
  end

  def show
  end

  def new
    @g_entidade = GEntidade.new
  end

  def edit
  end

  def create
    @g_entidade = GEntidade.new(g_entidade_params)

    if @g_entidade.save
      redirect_to @g_entidade, notice: "G entidade criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @g_entidade.update(g_entidade_params)
      redirect_to @g_entidade, notice: "G entidade atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @g_entidade.discard
    redirect_to g_entidades_path, notice: "G entidade removido com sucesso."
  end

  private

  def set_g_entidade
    @g_entidade = GEntidade.find(params[:id])
  end

  def g_entidade_params
    params.require(:g_entidade).permit(:descricao, :g_estado_id, :g_municipio_id)
  end
end
