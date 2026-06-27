class MEvento < ApplicationRecord
  include SoftDeletable
  include Uppercasable

  upcases :descricao

  belongs_to :g_entidade
  belongs_to :g_predio

  has_many :m_eventos_musicas
  has_many :m_musicas, through: :m_eventos_musicas

  before_validation :assign_g_entidade

  def to_s
    descricao
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["descricao", "data_inicio", "data_fim", "g_entidade_id", "g_predio_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  private

  def assign_g_entidade
    self.g_entidade_id ||= g_predio&.g_entidade_id
  end
end
