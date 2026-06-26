class GUsuario < ApplicationRecord
  include SoftDeletable

  devise :database_authenticatable, :registerable, :rememberable, :validatable

  belongs_to :g_pessoa

  has_many :u_usuarios_perfis
  has_many :u_perfis, through: :u_usuarios_perfis

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

  def self.ransackable_attributes(_auth_object = nil)
    ["email", "ativo", "primeiro_acesso", "g_pessoa_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
