class UPerfisFuncoesController < ApplicationController
  before_action :set_u_perfil_funcao, only: %i[show edit update destroy]

  def index
    @q = UPerfilFuncao.ransack(params[:q])
    @u_perfis_funcoes = @q.result.order(created_at: :desc)
    @pagy, @u_perfis_funcoes = pagy(@u_perfis_funcoes, limit: 10)
  end

  def show
  end

  def new
    @u_perfil_funcao = UPerfilFuncao.new
  end

  def edit
  end

  def create
    @u_perfil_funcao = UPerfilFuncao.new(u_perfil_funcao_params)

    if @u_perfil_funcao.save
      redirect_to u_perfis_funcoes_path, notice: "#{UPerfilFuncao.model_name.human} criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @u_perfil_funcao.update(u_perfil_funcao_params)
      redirect_to u_perfis_funcoes_path, notice: "#{UPerfilFuncao.model_name.human} atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @u_perfil_funcao.discard
    redirect_to u_perfis_funcoes_path, notice: "#{UPerfilFuncao.model_name.human} removido com sucesso."
  end

  private

  def set_u_perfil_funcao
    @u_perfil_funcao = UPerfilFuncao.find(params[:id])
  end

  def u_perfil_funcao_params
    params.require(:u_perfil_funcao).permit(:u_perfil_id, :u_funcao_id)
  end
end
