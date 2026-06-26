class UPerfisPermissoesController < ApplicationController
  before_action :set_u_perfil_permissao, only: %i[show edit update destroy]

  def index
    @q = UPerfilPermissao.ransack(params[:q])
    @u_perfis_permissoes = @q.result.order(created_at: :desc)
    @pagy, @u_perfis_permissoes = pagy(@u_perfis_permissoes, limit: 10)
  end

  def show
  end

  def new
    @u_perfil_permissao = UPerfilPermissao.new
  end

  def edit
  end

  def create
    @u_perfil_permissao = UPerfilPermissao.new(u_perfil_permissao_params)

    if @u_perfil_permissao.save
      redirect_to @u_perfil_permissao, notice: "U perfil permissao criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @u_perfil_permissao.update(u_perfil_permissao_params)
      redirect_to @u_perfil_permissao, notice: "U perfil permissao atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @u_perfil_permissao.discard
    redirect_to u_perfis_permissoes_path, notice: "U perfil permissao removido com sucesso."
  end

  private

  def set_u_perfil_permissao
    @u_perfil_permissao = UPerfilPermissao.find(params[:id])
  end

  def u_perfil_permissao_params
    params.require(:u_perfil_permissao).permit(:u_perfil_id, :u_permissao_id)
  end
end
