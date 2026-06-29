class MEventoMusica < ApplicationRecord
  include SoftDeletable

  belongs_to :g_entidade
  belongs_to :m_evento
  belongs_to :m_musica
  has_many :m_ensaio_musicas

  before_validation :assign_g_entidade

  def to_s
    [m_evento, m_musica].compact.join(" - ")
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["g_entidade_id", "m_evento_id", "m_musica_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  private

  def assign_g_entidade
    self.g_entidade_id ||= m_evento&.g_entidade_id || m_musica&.g_entidade_id
  end
end
