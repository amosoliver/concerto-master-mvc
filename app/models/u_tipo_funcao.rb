class UTipoFuncao < ApplicationRecord
  include SoftDeletable

  has_many :u_funcoes

  def to_s
    descricao
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["descricao", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
