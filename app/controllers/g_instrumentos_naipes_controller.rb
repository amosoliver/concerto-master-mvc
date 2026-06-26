class GInstrumentosNaipesController < ApplicationController
  before_action :set_g_instrumento_naipe, only: %i[show edit update destroy]

  def index
    @q = GInstrumentoNaipe.ransack(params[:q])
    @g_instrumentos_naipes = @q.result.order(created_at: :desc)
    @pagy, @g_instrumentos_naipes = pagy(@g_instrumentos_naipes, limit: 10)
  end

  def show
  end

  def new
    @g_instrumento_naipe = GInstrumentoNaipe.new
  end

  def edit
  end

  def create
    @g_instrumento_naipe = GInstrumentoNaipe.new(g_instrumento_naipe_params)

    if @g_instrumento_naipe.save
      redirect_to @g_instrumento_naipe, notice: "G instrumento naipe criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @g_instrumento_naipe.update(g_instrumento_naipe_params)
      redirect_to @g_instrumento_naipe, notice: "G instrumento naipe atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @g_instrumento_naipe.discard
    redirect_to g_instrumentos_naipes_path, notice: "G instrumento naipe removido com sucesso."
  end

  private

  def set_g_instrumento_naipe
    @g_instrumento_naipe = GInstrumentoNaipe.find(params[:id])
  end

  def g_instrumento_naipe_params
    params.require(:g_instrumento_naipe).permit(:g_instrumento_id, :g_naipe_id)
  end
end
