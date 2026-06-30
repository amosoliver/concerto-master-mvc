class MEnsaioMusica < ApplicationRecord
  include SoftDeletable

  belongs_to :m_ensaio
  belongs_to :m_evento_musica
  belongs_to :g_entidade

  before_validation :assign_g_entidade
  validate :evento_musica_da_mesma_entidade

  def to_s
    m_evento_musica&.to_s || super
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["m_ensaio_id", "m_evento_musica_id", "g_entidade_id", "observacao", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  private

  def assign_g_entidade
    self.g_entidade_id ||= m_ensaio&.g_entidade_id || m_evento_musica&.g_entidade_id || Current.g_entidade&.id
  end

  def evento_musica_da_mesma_entidade
    return if m_ensaio.blank? || m_evento_musica.blank?
    return if m_ensaio.g_entidade_id == m_evento_musica.g_entidade_id

    errors.add(:m_evento_musica_id, "deve pertencer à mesma entidade do ensaio.")
  end
end
