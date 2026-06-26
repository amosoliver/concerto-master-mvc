class GUsuario < ApplicationRecord
  include SoftDeletable

  belongs_to :g_pessoa

  def self.ransackable_attributes(_auth_object = nil)
    ["email", "encrypted_password", "ativo", "g_pessoa_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
