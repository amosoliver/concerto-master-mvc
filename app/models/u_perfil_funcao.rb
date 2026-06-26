class UPerfilFuncao < ApplicationRecord
  include SoftDeletable

  belongs_to :u_perfil
  belongs_to :u_funcao

  def self.ransackable_attributes(_auth_object = nil)
    ["u_perfil_id", "u_funcao_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
