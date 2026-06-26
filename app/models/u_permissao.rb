class UPermissao < ApplicationRecord
  include SoftDeletable

  has_many :u_perfis_permissoes
  has_many :u_perfis, through: :u_perfis_permissoes

  def to_s
    descricao
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["descricao", "controlador", "acao", "admin", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
