class UPermissoesController < ApplicationController
  before_action :set_u_permissao, only: %i[show edit update destroy]

  def index
    @q = UPermissao.ransack(params[:q])
    @u_permissoes = @q.result.order(created_at: :desc)
    @pagy, @u_permissoes = pagy(@u_permissoes, limit: 5)
  end

  def show
  end

  def new
    @u_permissao = UPermissao.new
  end

  def edit
  end

  def create
    @u_permissao = UPermissao.new(u_permissao_params)

    if @u_permissao.save
      redirect_to u_permissoes_path, notice: "#{UPermissao.model_name.human} criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @u_permissao.update(u_permissao_params)
      redirect_to u_permissoes_path, notice: "#{UPermissao.model_name.human} atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @u_permissao.discard
    redirect_to u_permissoes_path, notice: "#{UPermissao.model_name.human} removido com sucesso."
  end

  def atualizar
    total = SincronizadorPermissoesService.call
    redirect_to u_permissoes_path, notice: "#{total} permissões foram criadas, atualizadas ou removidas com sucesso. O perfil Administrador também foi atualizado automaticamente."
  rescue StandardError => error
    redirect_to u_permissoes_path, alert: "Erro ao atualizar permissões: #{error.message}"
  end

  private

  def set_u_permissao
    @u_permissao = UPermissao.find(params[:id])
  end

  def u_permissao_params
    params.require(:u_permissao).permit(:descricao, :controlador, :acao, :admin)
  end
end
