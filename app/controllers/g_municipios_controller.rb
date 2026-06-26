class GMunicipiosController < ApplicationController
  before_action :set_g_municipio, only: %i[show edit update destroy]

  def index
    @q = GMunicipio.ransack(params[:q])
    @g_municipios = @q.result.order(created_at: :desc)
    @pagy, @g_municipios = pagy(@g_municipios, limit: 10)
  end

  def show
  end

  def new
    @g_municipio = GMunicipio.new
  end

  def edit
  end

  def create
    @g_municipio = GMunicipio.new(g_municipio_params)

    if @g_municipio.save
      redirect_to @g_municipio, notice: "G municipio criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @g_municipio.update(g_municipio_params)
      redirect_to @g_municipio, notice: "G municipio atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @g_municipio.discard
    redirect_to g_municipios_path, notice: "G municipio removido com sucesso."
  end

  private

  def set_g_municipio
    @g_municipio = GMunicipio.find(params[:id])
  end

  def g_municipio_params
    params.require(:g_municipio).permit(:descricao, :codigo_ibge, :g_estado_id)
  end
end
