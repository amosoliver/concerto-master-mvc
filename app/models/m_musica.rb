class MMusica < ApplicationRecord
  include SoftDeletable
  include Uppercasable

  upcases :descricao

  belongs_to :m_compositor
  belongs_to :m_artista

  has_many :m_arranjos
  has_many :m_eventos_musicas
  has_many :m_eventos, through: :m_eventos_musicas

  def to_s
    descricao
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["descricao", "m_compositor_id", "m_artista_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
