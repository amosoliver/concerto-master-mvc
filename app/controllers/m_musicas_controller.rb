class MMusicasController < ApplicationController
  before_action :set_m_musica, only: %i[show edit update destroy]

  def index
    @q = MMusica.ransack(params[:q])
    @m_musicas = @q.result.order(created_at: :desc)
    @pagy, @m_musicas = pagy(@m_musicas, limit: 10)
  end

  def show
  end

  def new
    @m_musica = MMusica.new
  end

  def edit
  end

  def create
    @m_musica = MMusica.new(m_musica_params)

    if @m_musica.save
      redirect_to @m_musica, notice: "#{MMusica.model_name.human} criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @m_musica.update(m_musica_params)
      redirect_to @m_musica, notice: "#{MMusica.model_name.human} atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @m_musica.discard
    redirect_to m_musicas_path, notice: "#{MMusica.model_name.human} removido com sucesso."
  end

  private

  def set_m_musica
    @m_musica = MMusica.find(params[:id])
  end

  def m_musica_params
    params.require(:m_musica).permit(:descricao, :m_compositor_id, :m_artista_id)
  end
end
