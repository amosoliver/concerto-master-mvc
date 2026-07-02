class GUsuariosController < ApplicationController
  before_action :set_g_usuario, only: %i[show edit update destroy manage_perfis update_perfis]
  before_action :load_access_management_collections, only: %i[manage_perfis update_perfis]

  def index
    @q = tenant_scope(GUsuario).ransack(params[:q])
    @g_usuarios = @q.result.order(created_at: :desc)
    @pagy, @g_usuarios = pagy(@g_usuarios, limit: 5)
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

  def manage_perfis
  end

  def update_perfis
    submitted_pairs = selected_access_pairs
    existing = UUsuarioPerfil.with_discarded.where(g_usuario_id: @g_usuario.id).index_by { |record| [record.g_entidade_id, record.u_perfil_id] }

    submitted_pairs.each do |entity_id, perfil_id|
      record = existing[[entity_id, perfil_id]] || UUsuarioPerfil.new(g_usuario_id: @g_usuario.id, g_entidade_id: entity_id, u_perfil_id: perfil_id)
      next if record.persisted? && record.deleted_at.nil?

      record.deleted_at = nil
      record.save!
    end

    existing.each do |pair, record|
      next if submitted_pairs.include?(pair)
      next if record.deleted_at.present?

      record.update!(deleted_at: Time.current)
    end

    redirect_to manage_perfis_g_usuario_path(@g_usuario), notice: "Perfis atualizados com sucesso."
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

  def load_access_management_collections
    @available_entities = current_context_entidades.to_a
    @u_perfis = UPerfil.order(:descricao)
    @selected_accesses = @g_usuario.u_usuarios_perfis.each_with_object(Hash.new { |hash, key| hash[key] = [] }) do |access, memo|
      memo[access.g_entidade_id] << access.u_perfil_id
    end
  end

  def selected_access_pairs
    raw_accesses_param = params[:entity_profile_ids]
    raw_accesses = raw_accesses_param.respond_to?(:to_unsafe_h) ? raw_accesses_param.to_unsafe_h : raw_accesses_param.to_h
    allowed_entity_ids = @available_entities.map(&:id)
    allowed_profile_ids = @u_perfis.map(&:id)

    raw_accesses.each_with_object([]) do |(entity_id, perfil_ids), selected|
      normalized_entity_id = entity_id.to_i
      next unless allowed_entity_ids.include?(normalized_entity_id)

      Array(perfil_ids).reject(&:blank?).map(&:to_i).each do |perfil_id|
        next unless allowed_profile_ids.include?(perfil_id)

        pair = [normalized_entity_id, perfil_id]
        selected << pair unless selected.include?(pair)
      end
    end
  end
end
