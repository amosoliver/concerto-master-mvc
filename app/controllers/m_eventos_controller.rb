class MEventosController < ApplicationController
  before_action :set_m_evento, only: %i[show edit update destroy]

  def index
    @q = MEvento.ransack(params[:q])
    @m_eventos = @q.result.order(created_at: :desc)
    @pagy, @m_eventos = pagy(@m_eventos, limit: 10)
  end

  def show
  end

  def new
    @m_evento = MEvento.new
  end

  def edit
  end

  def create
    @m_evento = MEvento.new(m_evento_params)

    if @m_evento.save
      redirect_to @m_evento, notice: "#{MEvento.model_name.human} criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @m_evento.update(m_evento_params)
      redirect_to @m_evento, notice: "#{MEvento.model_name.human} atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @m_evento.discard
    redirect_to m_eventos_path, notice: "#{MEvento.model_name.human} removido com sucesso."
  end

  private

  def set_m_evento
    @m_evento = MEvento.find(params[:id])
  end

  def m_evento_params
    params.require(:m_evento).permit(:descricao, :data_inicio, :data_fim, :g_predio_id)
  end
end
