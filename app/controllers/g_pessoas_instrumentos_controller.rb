class GPessoasInstrumentosController < ApplicationController
  before_action :set_g_pessoas_instrumento, only: %i[show edit update destroy]

  def index
    @q = GPessoasInstrumento.ransack(params[:q])
    @g_pessoas_instrumentos = @q.result.order(created_at: :desc)
    @pagy, @g_pessoas_instrumentos = pagy(@g_pessoas_instrumentos, limit: 10)
  end

  def show
  end

  def new
    @g_pessoas_instrumento = GPessoasInstrumento.new
  end

  def edit
  end

  def create
    @g_pessoas_instrumento = GPessoasInstrumento.new(g_pessoas_instrumento_params)

    if @g_pessoas_instrumento.save
      redirect_to @g_pessoas_instrumento, notice: "G pessoas instrumento criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @g_pessoas_instrumento.update(g_pessoas_instrumento_params)
      redirect_to @g_pessoas_instrumento, notice: "G pessoas instrumento atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @g_pessoas_instrumento.discard
    redirect_to g_pessoas_instrumentos_path, notice: "G pessoas instrumento removido com sucesso."
  end

  private

  def set_g_pessoas_instrumento
    @g_pessoas_instrumento = GPessoasInstrumento.find(params[:id])
  end

  def g_pessoas_instrumento_params
    params.require(:g_pessoas_instrumento).permit(:g_pessoa_id, :g_instrumento_naipe_id)
  end
end
