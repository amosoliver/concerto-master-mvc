class UFuncoesController < ApplicationController
  before_action :set_u_funcao, only: %i[show edit update destroy]

  def index
    @q = UFuncao.ransack(params[:q])
    @u_funcoes = @q.result.order(created_at: :desc)
    @pagy, @u_funcoes = pagy(@u_funcoes, limit: 10)
  end

  def show
  end

  def new
    @u_funcao = UFuncao.new
  end

  def edit
  end

  def create
    @u_funcao = UFuncao.new(u_funcao_params)

    if @u_funcao.save
      redirect_to @u_funcao, notice: "#{UFuncao.model_name.human} criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @u_funcao.update(u_funcao_params)
      redirect_to @u_funcao, notice: "#{UFuncao.model_name.human} atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @u_funcao.discard
    redirect_to u_funcoes_path, notice: "#{UFuncao.model_name.human} removido com sucesso."
  end

  private

  def set_u_funcao
    @u_funcao = UFuncao.find(params[:id])
  end

  def u_funcao_params
    params.require(:u_funcao).permit(:descricao, :u_tipo_funcao_id)
  end
end
