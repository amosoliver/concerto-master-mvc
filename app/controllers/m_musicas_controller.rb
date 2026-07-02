class MMusicasController < ApplicationController
  before_action :set_m_musica, only: %i[show edit update destroy manage_arranjos]
  before_action :load_form_collections, only: %i[new create edit update]

  def index
    @q = tenant_scope(MMusica).ransack(params[:q])
    @m_musicas = @q.result.order(created_at: :desc)
    @pagy, @m_musicas = pagy(@m_musicas, limit: 5)
  end

  def show
  end

  def manage_arranjos
    @m_arranjos = @m_musica.m_arranjos
                           .includes(
                             :m_arranjador,
                             :m_tonalidade,
                             :m_tipo_arranjo,
                             audio_attachments: :blob,
                             m_arranjos_instrumentos_naipes: [
                               :g_instrumento_naipe,
                               { arquivo_attachments: :blob }
                             ]
                           )
                           .order(created_at: :desc)
  end

  def new
    @m_musica = MMusica.new
  end

  def edit
  end

  def create
    @m_musica = MMusica.new(m_musica_params)
    assign_virtual_attributes

    if MMusicas::ServicoCriacao.new(m_musica: @m_musica, params: m_musica_params).call
      redirect_to m_musicas_path, notice: "#{MMusica.model_name.human} criado com sucesso."
    end
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_entity
  end

  def update
    @m_musica.assign_attributes(m_musica_params)
    assign_virtual_attributes

    if MMusicas::ServicoAtualizacao.new(m_musica: @m_musica, params: m_musica_params).call
      redirect_to m_musicas_path, notice: "#{MMusica.model_name.human} atualizado com sucesso."
    end
  rescue ActiveRecord::RecordInvalid
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @m_musica.discard
    redirect_to m_musicas_path, notice: "#{MMusica.model_name.human} removido com sucesso."
  end

  private

  def set_m_musica
    @m_musica = tenant_record!(MMusica, params[:id])
  end

  def m_musica_params
    params.require(:m_musica).permit(:descricao, :m_compositor_id, :m_artista_id, :novo_m_compositor, :novo_m_artista, :url_referencia)
  end

  def load_form_collections
    @m_compositores = MCompositor.order(:descricao)
    @m_artistas = MArtista.order(:descricao)
  end

  def assign_virtual_attributes
    @m_musica.novo_m_compositor = m_musica_params[:novo_m_compositor]
    @m_musica.novo_m_artista = m_musica_params[:novo_m_artista]
  end
end
