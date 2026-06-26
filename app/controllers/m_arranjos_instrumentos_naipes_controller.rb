class MArranjosInstrumentosNaipesController < ApplicationController
  before_action :set_m_arranjo_instrumento_naipe, only: %i[show edit update destroy]

  def index
    @q = MArranjoInstrumentoNaipe.ransack(params[:q])
    @m_arranjos_instrumentos_naipes = @q.result.order(created_at: :desc)
    @pagy, @m_arranjos_instrumentos_naipes = pagy(@m_arranjos_instrumentos_naipes, limit: 10)
  end

  def show
  end

  def new
    @m_arranjo_instrumento_naipe = MArranjoInstrumentoNaipe.new
  end

  def edit
  end

  def create
    @m_arranjo_instrumento_naipe = MArranjoInstrumentoNaipe.new(m_arranjo_instrumento_naipe_params)

    if @m_arranjo_instrumento_naipe.save
      redirect_to @m_arranjo_instrumento_naipe, notice: "#{MArranjoInstrumentoNaipe.model_name.human} criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @m_arranjo_instrumento_naipe.update(m_arranjo_instrumento_naipe_params)
      redirect_to @m_arranjo_instrumento_naipe, notice: "#{MArranjoInstrumentoNaipe.model_name.human} atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @m_arranjo_instrumento_naipe.discard
    redirect_to m_arranjos_instrumentos_naipes_path, notice: "#{MArranjoInstrumentoNaipe.model_name.human} removido com sucesso."
  end

  private

  def set_m_arranjo_instrumento_naipe
    @m_arranjo_instrumento_naipe = MArranjoInstrumentoNaipe.find(params[:id])
  end

  def m_arranjo_instrumento_naipe_params
    params.require(:m_arranjo_instrumento_naipe).permit(:g_instrumento_naipe_id, :m_arranjo_id)
  end
end
