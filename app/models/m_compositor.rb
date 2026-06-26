class MCompositor < ApplicationRecord
  include SoftDeletable


  def self.ransackable_attributes(_auth_object = nil)
    ["descricao", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
