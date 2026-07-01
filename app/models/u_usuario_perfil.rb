class UUsuarioPerfil < ApplicationRecord
  include SoftDeletable

  belongs_to :g_entidade
  belongs_to :u_perfil
  belongs_to :g_usuario

  def self.ransackable_attributes(_auth_object = nil)
    ["u_perfil_id", "g_usuario_id", "g_entidade_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
