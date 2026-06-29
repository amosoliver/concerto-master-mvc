class MTipoArranjo < ApplicationRecord
  include SoftDeletable
  include Uppercasable

  self.table_name = "m_tipos_arranjos"

  upcases :descricao

  has_many :m_arranjos
  validates :descricao, presence: true

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
