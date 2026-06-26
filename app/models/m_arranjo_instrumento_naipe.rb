class MArranjoInstrumentoNaipe < ApplicationRecord
  include SoftDeletable

  belongs_to :g_instrumento_naipe
  belongs_to :m_arranjo

  def self.ransackable_attributes(_auth_object = nil)
    ["g_instrumento_naipe_id", "m_arranjo_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
