class GInstrumentosController < ApplicationController
  before_action :set_g_instrumento, only: %i[show edit update destroy]

  def index
    @q = GInstrumento.ransack(params[:q])
    @g_instrumentos = @q.result.order(created_at: :desc)
    @pagy, @g_instrumentos = pagy(@g_instrumentos, limit: 10)
  end

  def show
  end

  def new
    @g_instrumento = GInstrumento.new
  end

  def edit
  end

  def create
    @g_instrumento = GInstrumento.new(g_instrumento_params)

    if @g_instrumento.save
      redirect_to @g_instrumento, notice: "G instrumento criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @g_instrumento.update(g_instrumento_params)
      redirect_to @g_instrumento, notice: "G instrumento atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @g_instrumento.discard
    redirect_to g_instrumentos_path, notice: "G instrumento removido com sucesso."
  end

  private

  def set_g_instrumento
    @g_instrumento = GInstrumento.find(params[:id])
  end

  def g_instrumento_params
    params.require(:g_instrumento).permit(:descricao)
  end
end
