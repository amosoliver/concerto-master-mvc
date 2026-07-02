class GMunicipiosController < ApplicationController
  before_action :set_g_municipio, only: %i[show edit update destroy]

  def index
    @q = GMunicipio.ransack(params[:q])
    @g_municipios = @q.result
    @g_municipios = @g_municipios.where(g_estado_id: params[:g_estado_id]) if params[:g_estado_id].present?
    @g_municipios = @g_municipios.order(:descricao)

    respond_to do |format|
      format.json do
        render json: @g_municipios.select(:id, :descricao, :g_estado_id).map { |municipio|
          { id: municipio.id, descricao: municipio.descricao, g_estado_id: municipio.g_estado_id }
        }
      end
      format.html do
        @pagy, @g_municipios = pagy(@g_municipios, limit: 5)
      end
    end
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
      redirect_to g_municipios_path, notice: "#{GMunicipio.model_name.human} criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @g_municipio.update(g_municipio_params)
      redirect_to g_municipios_path, notice: "#{GMunicipio.model_name.human} atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @g_municipio.discard
    redirect_to g_municipios_path, notice: "#{GMunicipio.model_name.human} removido com sucesso."
  end

  private

  def set_g_municipio
    @g_municipio = GMunicipio.find(params[:id])
  end

  def g_municipio_params
    params.require(:g_municipio).permit(:descricao, :codigo_ibge, :g_estado_id)
  end
end
