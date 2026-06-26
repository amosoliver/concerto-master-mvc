class GSexo < ApplicationRecord
  include SoftDeletable

  def self.ransackable_attributes(_auth_object = nil)
    ["created_at", "deleted_at", "descricao", "id", "updated_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
