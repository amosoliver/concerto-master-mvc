class UFuncao < ApplicationRecord
  include SoftDeletable

  belongs_to :u_tipo_funcao

  def self.ransackable_attributes(_auth_object = nil)
    ["descricao", "u_tipo_funcao_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
