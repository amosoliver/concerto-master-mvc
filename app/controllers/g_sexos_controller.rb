class GSexosController < ApplicationController
  before_action :set_g_sexo, only: %i[show edit update destroy]

  def index
    @q = GSexo.ransack(params[:q])
    @g_sexos = @q.result.order(created_at: :desc)
    @pagy, @g_sexos = pagy(@g_sexos, limit: 10)
  end

  def show
  end

  def new
    @g_sexo = GSexo.new
  end

  def edit
  end

  def create
    @g_sexo = GSexo.new(g_sexo_params)

    if @g_sexo.save
      redirect_to g_sexos_path, notice: "#{GSexo.model_name.human} criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @g_sexo.update(g_sexo_params)
      redirect_to g_sexos_path, notice: "#{GSexo.model_name.human} atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @g_sexo.discard
    redirect_to g_sexos_path, notice: "#{GSexo.model_name.human} removido com sucesso."
  end

  private

  def set_g_sexo
    @g_sexo = GSexo.find(params[:id])
  end

  def g_sexo_params
    params.require(:g_sexo).permit(:descricao)
  end
end
