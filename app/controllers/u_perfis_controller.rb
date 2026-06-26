class UPerfisController < ApplicationController
  helper_method :section_title

  before_action :set_u_perfil, only: %i[show edit update destroy]
  before_action :load_form_collections, only: %i[new create edit update]

  def index
    @q = UPerfil.ransack(params[:q])
    @u_perfis = @q.result.order(created_at: :desc)
    @pagy, @u_perfis = pagy(@u_perfis, limit: 10)
  end

  def show
    redirect_to edit_u_perfil_path(@u_perfil)
  end

  def new
    @u_perfil = UPerfil.new
  end

  def edit
  end

  def create
    @u_perfil = UPerfil.new(u_perfil_params)

    UPerfil.transaction do
      @u_perfil.save!
      sync_relations!(@u_perfil)
    end

    redirect_to u_perfis_path, notice: "#{UPerfil.model_name.human} criado com sucesso."
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_entity
  end

  def update
    UPerfil.transaction do
      @u_perfil.update!(u_perfil_params)
      sync_relations!(@u_perfil)
    end

    redirect_to u_perfis_path, notice: "#{UPerfil.model_name.human} atualizado com sucesso."
  rescue ActiveRecord::RecordInvalid
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @u_perfil.discard
    redirect_to u_perfis_path, notice: "#{UPerfil.model_name.human} removido com sucesso."
  end

  private

  def set_u_perfil
    @u_perfil = UPerfil.find(params[:id])
  end

  def u_perfil_params
    params.require(:u_perfil).permit(:descricao)
  end
  def load_form_collections
    @u_permissoes = UPermissao.order(:descricao)
    @u_funcoes = UFuncao.order(:descricao)
  end

  def sync_relations!(u_perfil)
    u_perfil.sync_u_permissoes!(params.dig(:u_perfil, :u_permissao_ids))
    u_perfil.sync_u_funcoes!(params.dig(:u_perfil, :u_funcao_ids))
  end

  def section_title(section)
    case section
    when "funcoes" then "Funções do perfil"
    when "permissoes" then "Permissões do perfil"
    else "Perfil completo"
    end
  end
end
