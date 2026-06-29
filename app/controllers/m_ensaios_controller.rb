class MEnsaiosController < ApplicationController
  before_action :set_m_ensaio, only: %i[show edit update destroy]
  before_action :load_form_collections, only: %i[new create edit update]

  def index
    @q = tenant_scope(MEnsaio).ransack(params[:q])
    @m_ensaios = @q.result.order(created_at: :desc)
    @pagy, @m_ensaios = pagy(@m_ensaios, limit: 10)
  end

  def show
  end

  def new
    @m_ensaio = MEnsaio.new
  end

  def edit
  end

  def create
    @m_ensaio = MEnsaio.new(m_ensaio_params)

    if @m_ensaio.save
      redirect_to m_ensaios_path, notice: "#{MEnsaio.model_name.human} criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @m_ensaio.update(m_ensaio_params)
      redirect_to m_ensaios_path, notice: "#{MEnsaio.model_name.human} atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @m_ensaio.discard
    redirect_to m_ensaios_path, notice: "#{MEnsaio.model_name.human} removido com sucesso."
  end

  private

  def set_m_ensaio
    @m_ensaio = tenant_record!(MEnsaio, params[:id])
  end

  def m_ensaio_params
    params.require(:m_ensaio).permit(:descricao, :data_inicio, :data_fim, :g_predio_id)
  end

  def load_form_collections
    @g_predios = tenant_predio_scope
  end
end
