class MEvento < ApplicationRecord
  include SoftDeletable

  belongs_to :g_predio

  def self.ransackable_attributes(_auth_object = nil)
    ["descricao", "data_inicio", "data_fim", "g_predio_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
