class MEnsaioMusica < ApplicationRecord
  include SoftDeletable

  belongs_to :m_ensaio
  belongs_to :m_evento_musica
  belongs_to :g_entidade

  before_validation :assign_g_entidade

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
end
