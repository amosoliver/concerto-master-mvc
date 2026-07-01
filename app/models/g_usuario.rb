require "set"

class GUsuario < ApplicationRecord
  include SoftDeletable

  devise :database_authenticatable, :registerable, :rememberable, :validatable

  belongs_to :g_pessoa

  has_many :u_usuarios_perfis
  has_many :u_perfis, through: :u_usuarios_perfis
  has_many :u_permissoes, -> { distinct }, through: :u_perfis
  has_many :entidades_de_acesso, -> { distinct }, through: :u_usuarios_perfis, source: :g_entidade

  attr_writer :login

  def login
    @login || email
  end

  # Allows signing in with either the account email or the person's CPF.
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login).to_s
    cpf = login.gsub(/\D/, "")

    joins(:g_pessoa).find_by(
      ["g_usuarios.email = :login OR g_pessoas.cpf = :cpf", { login: login, cpf: cpf }]
    )
  end

  def active_for_authentication?
    super && ativo?
  end

  def inactive_message
    ativo? ? super : :inactive_account
  end

  def to_s
    email
  end

  def allowed_to?(controller_name, action_name)
    permission_keys.include?("#{controller_name}##{action_name}")
  end

  def permission_keys
    current_entity_id = Current.g_entidade&.id || :none
    @permission_keys_by_entity ||= {}
    @permission_keys_by_entity[current_entity_id] ||= scoped_u_permissoes_for(Current.g_entidade)
      .pluck(:controlador, :acao)
      .map { |controller_name, action_name| "#{controller_name}##{action_name}" }
      .to_set
  end

  def accessible_root_entities(base_entity: nil)
    entities = entidades_de_acesso.order(:descricao).to_a
    if base_entity.present? && entities.none? { |entidade| entidade.id == base_entity.id }
      entities.unshift(base_entity)
    end

    entities.uniq(&:id)
  end

  def accessible_entity_ids(base_entity: nil)
    accessible_root_entities(base_entity: base_entity).flat_map(&:self_and_descendant_ids).uniq
  end

  def perfis_ativos_para(entidade)
    return UPerfil.none if entidade.blank?

    u_perfis
      .joins(:u_usuarios_perfis)
      .where(u_usuarios_perfis: { g_usuario_id: id, g_entidade_id: entidade.self_and_ancestor_ids })
      .distinct
  end

  def admin_for?(entidade)
    return false if entidade.blank?

    current_entity_id = entidade.id
    @admin_flags_by_entity ||= {}
    @admin_flags_by_entity[current_entity_id] ||= scoped_u_permissoes_for(entidade).where(admin: true).exists?
  end

  private

  def scoped_u_permissoes_for(entidade)
    return UPermissao.none if entidade.blank?

    UPermissao
      .joins(u_perfis: :u_usuarios_perfis)
      .where(u_usuarios_perfis: { g_usuario_id: id, g_entidade_id: entidade.self_and_ancestor_ids })
      .distinct
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["email", "ativo", "primeiro_acesso", "g_pessoa_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
