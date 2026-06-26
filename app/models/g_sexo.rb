class GSexo < ApplicationRecord
  include SoftDeletable

  has_many :g_pessoas

  def to_s
    descricao
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["created_at", "deleted_at", "descricao", "id", "updated_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
