class GUsuariosController < ApplicationController
  before_action :set_g_usuario, only: %i[show edit update destroy]

  def index
    @q = GUsuario.ransack(params[:q])
    @g_usuarios = @q.result.order(created_at: :desc)
    @pagy, @g_usuarios = pagy(@g_usuarios, limit: 10)
  end

  def show
  end

  def new
    @g_usuario = GUsuario.new
  end

  def edit
  end

  def create
    @g_usuario = GUsuario.new(g_usuario_params)

    if @g_usuario.save
      redirect_to @g_usuario, notice: "G usuario criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @g_usuario.update(g_usuario_params)
      redirect_to @g_usuario, notice: "G usuario atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @g_usuario.discard
    redirect_to g_usuarios_path, notice: "G usuario removido com sucesso."
  end

  private

  def set_g_usuario
    @g_usuario = GUsuario.find(params[:id])
  end

  def g_usuario_params
    params.require(:g_usuario).permit(:email, :encrypted_password, :ativo, :g_pessoa_id)
  end
end
