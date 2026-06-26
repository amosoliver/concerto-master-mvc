class UFuncao < ApplicationRecord
  include SoftDeletable

  belongs_to :u_tipo_funcao

  has_many :u_perfis_funcoes
  has_many :u_perfis, through: :u_perfis_funcoes
  has_many :m_pessoas_funcoes
  has_many :g_pessoas, through: :m_pessoas_funcoes

  def to_s
    descricao
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["descricao", "u_tipo_funcao_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
