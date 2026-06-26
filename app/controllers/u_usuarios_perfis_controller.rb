class UUsuariosPerfisController < ApplicationController
  before_action :set_u_usuario_perfil, only: %i[show edit update destroy]

  def index
    @q = UUsuarioPerfil.ransack(params[:q])
    @u_usuarios_perfis = @q.result.order(created_at: :desc)
    @pagy, @u_usuarios_perfis = pagy(@u_usuarios_perfis, limit: 10)
  end

  def show
  end

  def new
    @selected_g_usuario = GUsuario.find_by(id: params[:g_usuario_id])
    @u_usuario_perfil = UUsuarioPerfil.new(
      g_usuario_id: @selected_g_usuario&.id || params[:g_usuario_id],
      u_perfil_id: params[:u_perfil_id]
    )
  end

  def edit
  end

  def create
    @u_usuario_perfil = UUsuarioPerfil.new(u_usuario_perfil_params)

    if @u_usuario_perfil.save
      redirect_to @u_usuario_perfil, notice: "#{UUsuarioPerfil.model_name.human} criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @u_usuario_perfil.update(u_usuario_perfil_params)
      redirect_to @u_usuario_perfil, notice: "#{UUsuarioPerfil.model_name.human} atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @u_usuario_perfil.discard
    redirect_to u_usuarios_perfis_path, notice: "#{UUsuarioPerfil.model_name.human} removido com sucesso."
  end

  private

  def set_u_usuario_perfil
    @u_usuario_perfil = UUsuarioPerfil.find(params[:id])
  end

  def u_usuario_perfil_params
    params.require(:u_usuario_perfil).permit(:u_perfil_id, :g_usuario_id)
  end
end
