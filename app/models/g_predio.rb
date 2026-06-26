class GPredio < ApplicationRecord
  include SoftDeletable

  belongs_to :g_entidade

  def self.ransackable_attributes(_auth_object = nil)
    ["nome_fantasia", "cep", "logradouro", "bairro", "g_entidade_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
