class GInstrumentosNaipesController < ApplicationController
  before_action :set_g_instrumento_naipe, only: %i[show edit update destroy]
  before_action :load_form_collections, only: %i[new create edit update]

  def index
    @q = GInstrumentoNaipe.ransack(params[:q])
    @g_instrumentos_naipes = @q.result.order(created_at: :desc)
    @pagy, @g_instrumentos_naipes = pagy(@g_instrumentos_naipes, limit: 5)
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
    assign_virtual_attributes

    if GInstrumentosNaipes::ServicoCriacao.new(g_instrumento_naipe: @g_instrumento_naipe, params: g_instrumento_naipe_params).call
      redirect_to g_instrumentos_naipes_path, notice: "#{GInstrumentoNaipe.model_name.human} criado com sucesso."
    end
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_entity
  end

  def update
    @g_instrumento_naipe.assign_attributes(g_instrumento_naipe_params)
    assign_virtual_attributes

    if GInstrumentosNaipes::ServicoAtualizacao.new(g_instrumento_naipe: @g_instrumento_naipe, params: g_instrumento_naipe_params).call
      redirect_to g_instrumentos_naipes_path, notice: "#{GInstrumentoNaipe.model_name.human} atualizado com sucesso."
    end
  rescue ActiveRecord::RecordInvalid
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @g_instrumento_naipe.discard
    redirect_to g_instrumentos_naipes_path, notice: "#{GInstrumentoNaipe.model_name.human} removido com sucesso."
  end

  private

  def set_g_instrumento_naipe
    @g_instrumento_naipe = GInstrumentoNaipe.find(params[:id])
  end

  def g_instrumento_naipe_params
    params.require(:g_instrumento_naipe).permit(:g_instrumento_id, :g_naipe_id, :novo_g_instrumento, :novo_g_naipe)
  end

  def load_form_collections
    @g_instrumentos = GInstrumento.order(:descricao)
    @g_naipes = GNaipe.order(:descricao)
  end

  def assign_virtual_attributes
    @g_instrumento_naipe.novo_g_instrumento = g_instrumento_naipe_params[:novo_g_instrumento]
    @g_instrumento_naipe.novo_g_naipe = g_instrumento_naipe_params[:novo_g_naipe]
  end
end
