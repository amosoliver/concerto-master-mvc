class MEventoMusicaGrupo < ApplicationRecord
  include SoftDeletable

  belongs_to :m_evento_musica
  belongs_to :m_grupo
  belongs_to :g_entidade

  before_validation :assign_g_entidade
  validate :grupo_da_mesma_entidade

  def self.ransackable_attributes(_auth_object = nil)
    ["m_evento_musica_id", "m_grupo_id", "g_entidade_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  private

  def assign_g_entidade
    self.g_entidade_id ||= m_evento_musica&.g_entidade_id || m_grupo&.g_entidade_id || Current.g_entidade&.id
  end

  def grupo_da_mesma_entidade
    return if m_evento_musica.blank? || m_grupo.blank?
    return if m_evento_musica.g_entidade_id == m_grupo.g_entidade_id

    errors.add(:m_grupo_id, "deve pertencer à mesma entidade do item do repertório.")
  end
end
