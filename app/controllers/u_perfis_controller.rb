class UPerfisController < ApplicationController
  before_action :set_u_perfil, only: %i[show edit update destroy]

  def index
    @q = UPerfil.ransack(params[:q])
    @u_perfis = @q.result.order(created_at: :desc)
    @pagy, @u_perfis = pagy(@u_perfis, limit: 10)
  end

  def show
  end

  def new
    @u_perfil = UPerfil.new
  end

  def edit
  end

  def create
    @u_perfil = UPerfil.new(u_perfil_params)

    if @u_perfil.save
      redirect_to @u_perfil, notice: "U perfil criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @u_perfil.update(u_perfil_params)
      redirect_to @u_perfil, notice: "U perfil atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @u_perfil.discard
    redirect_to u_perfis_path, notice: "U perfil removido com sucesso."
  end

  private

  def set_u_perfil
    @u_perfil = UPerfil.find(params[:id])
  end

  def u_perfil_params
    params.require(:u_perfil).permit(:descricao)
  end
end
