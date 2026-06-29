class MEventosMusicasController < ApplicationController
  before_action :set_m_evento_musica, only: %i[show edit update destroy]

  def index
    @q = tenant_scope(MEventoMusica).ransack(params[:q])
    @m_eventos_musicas = @q.result.order(created_at: :desc)
    @pagy, @m_eventos_musicas = pagy(@m_eventos_musicas, limit: 10)
  end

  def show
  end

  def new
    @m_evento_musica = MEventoMusica.new
  end

  def edit
  end

  def create
    @m_evento_musica = MEventoMusica.new(m_evento_musica_params)

    if @m_evento_musica.save
      redirect_to m_eventos_musicas_path, notice: "#{MEventoMusica.model_name.human} criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @m_evento_musica.update(m_evento_musica_params)
      redirect_to m_eventos_musicas_path, notice: "#{MEventoMusica.model_name.human} atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @m_evento_musica.discard
    redirect_to m_eventos_musicas_path, notice: "#{MEventoMusica.model_name.human} removido com sucesso."
  end

  private

  def set_m_evento_musica
    @m_evento_musica = tenant_record!(MEventoMusica, params[:id])
  end

  def m_evento_musica_params
    params.require(:m_evento_musica).permit(:m_evento_id, :m_musica_id)
  end
end
