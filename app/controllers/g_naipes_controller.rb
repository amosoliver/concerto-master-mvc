class GNaipesController < ApplicationController
  before_action :set_g_naipe, only: %i[show edit update destroy]

  def index
    @q = GNaipe.ransack(params[:q])
    @g_naipes = @q.result.order(created_at: :desc)
    @pagy, @g_naipes = pagy(@g_naipes, limit: 10)
  end

  def show
  end

  def new
    @g_naipe = GNaipe.new
  end

  def edit
  end

  def create
    @g_naipe = GNaipe.new(g_naipe_params)

    if @g_naipe.save
      redirect_to g_naipes_path, notice: "#{GNaipe.model_name.human} criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @g_naipe.update(g_naipe_params)
      redirect_to g_naipes_path, notice: "#{GNaipe.model_name.human} atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @g_naipe.discard
    redirect_to g_naipes_path, notice: "#{GNaipe.model_name.human} removido com sucesso."
  end

  private

  def set_g_naipe
    @g_naipe = GNaipe.find(params[:id])
  end

  def g_naipe_params
    params.require(:g_naipe).permit(:descricao)
  end
end
