class MArranjadoresController < ApplicationController
  before_action :set_m_arranjador, only: %i[show edit update destroy]

  def index
    @q = MArranjador.ransack(params[:q])
    @m_arranjadores = @q.result.order(created_at: :desc)
    @pagy, @m_arranjadores = pagy(@m_arranjadores, limit: 10)
  end

  def show
  end

  def new
    @m_arranjador = MArranjador.new
  end

  def edit
  end

  def create
    @m_arranjador = MArranjador.new(m_arranjador_params)

    if @m_arranjador.save
      redirect_to @m_arranjador, notice: "M arranjador criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @m_arranjador.update(m_arranjador_params)
      redirect_to @m_arranjador, notice: "M arranjador atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @m_arranjador.discard
    redirect_to m_arranjadores_path, notice: "M arranjador removido com sucesso."
  end

  private

  def set_m_arranjador
    @m_arranjador = MArranjador.find(params[:id])
  end

  def m_arranjador_params
    params.require(:m_arranjador).permit(:descricao)
  end
end
