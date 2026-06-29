class UTiposFuncoesController < ApplicationController
  before_action :set_u_tipo_funcao, only: %i[show edit update destroy]

  def index
    @q = UTipoFuncao.ransack(params[:q])
    @u_tipos_funcoes = @q.result.order(created_at: :desc)
    @pagy, @u_tipos_funcoes = pagy(@u_tipos_funcoes, limit: 10)
  end

  def show
  end

  def new
    @u_tipo_funcao = UTipoFuncao.new
  end

  def edit
  end

  def create
    @u_tipo_funcao = UTipoFuncao.new(u_tipo_funcao_params)

    if @u_tipo_funcao.save
      redirect_to u_tipos_funcoes_path, notice: "#{UTipoFuncao.model_name.human} criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @u_tipo_funcao.update(u_tipo_funcao_params)
      redirect_to u_tipos_funcoes_path, notice: "#{UTipoFuncao.model_name.human} atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @u_tipo_funcao.discard
    redirect_to u_tipos_funcoes_path, notice: "#{UTipoFuncao.model_name.human} removido com sucesso."
  end

  private

  def set_u_tipo_funcao
    @u_tipo_funcao = UTipoFuncao.find(params[:id])
  end

  def u_tipo_funcao_params
    params.require(:u_tipo_funcao).permit(:descricao)
  end
end
