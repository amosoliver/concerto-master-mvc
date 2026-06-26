class MMusica < ApplicationRecord
  include SoftDeletable

  belongs_to :m_compositor
  belongs_to :m_artista

  def self.ransackable_attributes(_auth_object = nil)
    ["descricao", "m_compositor_id", "m_artista_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
