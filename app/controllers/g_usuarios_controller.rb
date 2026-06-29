class GUsuariosController < ApplicationController
  before_action :set_g_usuario, only: %i[show edit update destroy]

  def index
    @q = tenant_scope(GUsuario).ransack(params[:q])
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
    normalize_g_usuario_password!(@g_usuario, creating: true)

    if @g_usuario.save
      redirect_to g_usuarios_path, notice: "#{GUsuario.model_name.human} criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    normalize_g_usuario_password!(@g_usuario, creating: false)

    if @g_usuario.update(g_usuario_params)
      redirect_to g_usuarios_path, notice: "#{GUsuario.model_name.human} atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @g_usuario.discard
    redirect_to g_usuarios_path, notice: "#{GUsuario.model_name.human} removido com sucesso."
  end

  private

  def set_g_usuario
    @g_usuario = tenant_record!(GUsuario, params[:id])
  end

  def g_usuario_params
    params.require(:g_usuario).permit(:email, :password, :password_confirmation, :ativo, :g_pessoa_id)
  end

  def normalize_g_usuario_password!(g_usuario, creating:)
    password = g_usuario_params[:password].to_s
    password_confirmation = g_usuario_params[:password_confirmation].to_s

    if creating && password.blank?
      g_usuario.password = default_password
      g_usuario.password_confirmation = default_password
      g_usuario.primeiro_acesso = true
      return
    end

    if password.blank?
      params[:g_usuario].delete(:password)
      params[:g_usuario].delete(:password_confirmation)
      return
    end

    g_usuario.primeiro_acesso = false if password_confirmation.present?
  end

  def default_password
    "102030"
  end
end
