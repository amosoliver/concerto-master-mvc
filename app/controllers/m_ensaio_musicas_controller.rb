class MEnsaioMusicasController < ApplicationController
  before_action :set_m_ensaio_musica, only: %i[show edit update destroy]
  before_action :load_form_collections, only: %i[new create edit update]

  def index
    @q = tenant_scope(MEnsaioMusica).ransack(params[:q])
    @m_ensaio_musicas = @q.result.order(created_at: :desc)
    @pagy, @m_ensaio_musicas = pagy(@m_ensaio_musicas, limit: 10)
  end

  def show
  end

  def new
    @m_ensaio_musica = MEnsaioMusica.new
  end

  def edit
  end

  def create
    @m_ensaio_musica = MEnsaioMusica.new(m_ensaio_musica_params)

    if @m_ensaio_musica.save
      redirect_to m_ensaio_musicas_path, notice: "#{MEnsaioMusica.model_name.human} criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @m_ensaio_musica.update(m_ensaio_musica_params)
      redirect_to m_ensaio_musicas_path, notice: "#{MEnsaioMusica.model_name.human} atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @m_ensaio_musica.discard
    redirect_to m_ensaio_musicas_path, notice: "#{MEnsaioMusica.model_name.human} removido com sucesso."
  end

  private

  def set_m_ensaio_musica
    @m_ensaio_musica = tenant_record!(MEnsaioMusica, params[:id])
  end

  def m_ensaio_musica_params
    params.require(:m_ensaio_musica).permit(:m_ensaio_id, :m_evento_musica_id, :observacao)
  end

  def load_form_collections
    @m_ensaios = tenant_scope(MEnsaio).order(created_at: :desc)
    @m_eventos_musicas = tenant_scope(MEventoMusica).includes(:m_evento, :m_musica).order(created_at: :desc)
  end
end
