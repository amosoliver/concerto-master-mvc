class GMunicipio < ApplicationRecord
  include SoftDeletable

  belongs_to :g_estado

  has_many :g_entidades

  def to_s
    descricao
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["descricao", "codigo_ibge", "g_estado_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
