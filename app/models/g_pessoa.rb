class GPessoa < ApplicationRecord
  include SoftDeletable
  include Uppercasable

  upcases :nome

  belongs_to :g_entidade
  belongs_to :g_sexo

  has_many :g_usuarios
  has_many :g_pessoas_instrumentos
  has_many :g_instrumentos_naipes, through: :g_pessoas_instrumentos
  has_many :m_pessoas_funcoes
  has_many :u_funcoes, through: :m_pessoas_funcoes
  has_many :m_grupos_pessoas
  has_many :m_grupos, through: :m_grupos_pessoas

  before_validation { self.cpf = cpf.gsub(/\D/, "") if cpf.present? }

  def g_usuario_principal
    g_usuarios.first
  end

  def principal_u_funcao_id
    m_pessoas_funcoes.find_by(principal: true)&.u_funcao_id
  end

  def to_s
    nome
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["nome", "email", "cpf", "g_entidade_id", "g_sexo_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
