class MArtistasController < ApplicationController
  before_action :set_m_artista, only: %i[show edit update destroy]

  def index
    @q = MArtista.ransack(params[:q])
    @m_artistas = @q.result.order(created_at: :desc)
    @pagy, @m_artistas = pagy(@m_artistas, limit: 10)
  end

  def show
  end

  def new
    @m_artista = MArtista.new
  end

  def edit
  end

  def create
    @m_artista = MArtista.new(m_artista_params)

    if @m_artista.save
      redirect_to @m_artista, notice: "#{MArtista.model_name.human} criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @m_artista.update(m_artista_params)
      redirect_to @m_artista, notice: "#{MArtista.model_name.human} atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @m_artista.discard
    redirect_to m_artistas_path, notice: "#{MArtista.model_name.human} removido com sucesso."
  end

  private

  def set_m_artista
    @m_artista = MArtista.find(params[:id])
  end

  def m_artista_params
    params.require(:m_artista).permit(:descricao)
  end
end
