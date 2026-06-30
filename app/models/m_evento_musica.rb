class MEventoMusica < ApplicationRecord
  include SoftDeletable

  belongs_to :g_entidade
  belongs_to :m_evento
  belongs_to :m_musica
  belongs_to :m_arranjo, optional: true
  has_many :m_ensaio_musicas
  has_many :m_evento_musica_grupos
  has_many :m_grupos, through: :m_evento_musica_grupos

  before_validation :assign_g_entidade
  validate :unique_active_event_song
  validate :arranjo_belongs_to_musica

  def to_s
    [m_evento, m_musica].compact.join(" - ")
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["g_entidade_id", "m_arranjo_id", "m_evento_id", "m_musica_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  def grupos_label
    return "Todos os grupos" if m_grupos.empty?

    m_grupos.map(&:descricao).join(", ")
  end

  private

  def assign_g_entidade
    self.g_entidade_id ||= m_evento&.g_entidade_id || m_musica&.g_entidade_id
  end

  def unique_active_event_song
    return if m_evento_id.blank? || m_musica_id.blank?

    existing = self.class.where(m_evento_id: m_evento_id, m_musica_id: m_musica_id, deleted_at: nil).where.not(id: id)
    errors.add(:m_musica_id, "já está vinculada a este evento.") if existing.exists?
  end

  def arranjo_belongs_to_musica
    return if m_arranjo.blank? || m_musica.blank?
    return if m_arranjo.m_musica_id == m_musica_id

    errors.add(:m_arranjo_id, "deve pertencer à música selecionada.")
  end
end
