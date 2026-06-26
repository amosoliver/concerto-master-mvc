class GInstrumentoNaipe < ApplicationRecord
  include SoftDeletable

  belongs_to :g_instrumento
  belongs_to :g_naipe

  def self.ransackable_attributes(_auth_object = nil)
    ["g_instrumento_id", "g_naipe_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
