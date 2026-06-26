class GPessoasInstrumento < ApplicationRecord
  include SoftDeletable

  belongs_to :g_pessoa
  belongs_to :g_instrumento_naipe

  def self.ransackable_attributes(_auth_object = nil)
    ["g_pessoa_id", "g_instrumento_naipe_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
