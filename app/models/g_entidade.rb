class GEntidade < ApplicationRecord
  include SoftDeletable

  belongs_to :g_estado
  belongs_to :g_municipio

  def self.ransackable_attributes(_auth_object = nil)
    ["descricao", "g_estado_id", "g_municipio_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
