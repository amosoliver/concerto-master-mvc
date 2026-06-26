class UPermissao < ApplicationRecord
  include SoftDeletable


  def self.ransackable_attributes(_auth_object = nil)
    ["descricao", "controlador", "acao", "admin", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
