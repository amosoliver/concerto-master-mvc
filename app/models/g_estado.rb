class GEstado < ApplicationRecord
  include SoftDeletable

  belongs_to :g_pais

  has_many :g_municipios
  has_many :g_entidades

  def to_s
    descricao
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["descricao", "sigla", "codigo_ibge", "g_pais_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
