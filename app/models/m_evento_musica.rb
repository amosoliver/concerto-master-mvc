class MEventoMusica < ApplicationRecord
  include SoftDeletable

  belongs_to :m_evento
  belongs_to :m_musica

  def self.ransackable_attributes(_auth_object = nil)
    ["m_evento_id", "m_musica_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
