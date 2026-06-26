class GInstrumento < ApplicationRecord
  include SoftDeletable

  has_many :g_instrumentos_naipes
  has_many :g_naipes, through: :g_instrumentos_naipes

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
