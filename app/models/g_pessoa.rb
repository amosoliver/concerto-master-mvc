class GPessoa < ApplicationRecord
  include SoftDeletable

  belongs_to :g_entidade
  belongs_to :g_sexo

  def self.ransackable_attributes(_auth_object = nil)
    ["nome", "email", "g_entidade_id", "g_sexo_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
