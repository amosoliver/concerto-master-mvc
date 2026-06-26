class GPais < ApplicationRecord
  include SoftDeletable

  has_many :g_estados

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
