class MCompositoresController < ApplicationController
  before_action :set_m_compositor, only: %i[show edit update destroy]

  def index
    @q = MCompositor.ransack(params[:q])
    @m_compositores = @q.result.order(created_at: :desc)
    @pagy, @m_compositores = pagy(@m_compositores, limit: 10)
  end

  def show
  end

  def new
    @m_compositor = MCompositor.new
  end

  def edit
  end

  def create
    @m_compositor = MCompositor.new(m_compositor_params)

    if @m_compositor.save
      redirect_to @m_compositor, notice: "#{MCompositor.model_name.human} criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @m_compositor.update(m_compositor_params)
      redirect_to @m_compositor, notice: "#{MCompositor.model_name.human} atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @m_compositor.discard
    redirect_to m_compositores_path, notice: "#{MCompositor.model_name.human} removido com sucesso."
  end

  private

  def set_m_compositor
    @m_compositor = MCompositor.find(params[:id])
  end

  def m_compositor_params
    params.require(:m_compositor).permit(:descricao)
  end
end
