class Example < ApplicationRecord
  include SoftDeletable
  include Uppercasable

  upcases :name

  validates :name, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    ["created_at", "deleted_at", "description", "id", "name", "updated_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
