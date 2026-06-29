class MEnsaio < ApplicationRecord
  include SoftDeletable

  belongs_to :g_predio
  belongs_to :g_entidade

  has_many :m_ensaio_musicas
  has_many :m_evento_musicas, through: :m_ensaio_musicas
  has_many :m_musicas, through: :m_evento_musicas

  before_validation :assign_g_entidade

  def self.ransackable_attributes(_auth_object = nil)
    ["descricao", "data_inicio", "data_fim", "g_predio_id", "g_entidade_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  def to_s
    descricao
  end

  private

  def assign_g_entidade
    self.g_entidade_id ||= g_predio&.g_entidade_id || Current.g_entidade&.id
  end
end
