class MArranjo < ApplicationRecord
  include SoftDeletable

  belongs_to :g_entidade
  belongs_to :m_musica
  belongs_to :m_arranjador
  belongs_to :m_tonalidade

  has_many :m_arranjos_instrumentos_naipes
  has_many :g_instrumentos_naipes, through: :m_arranjos_instrumentos_naipes

  before_validation :assign_g_entidade

  def to_s
    "#{m_musica} - #{m_arranjador}"
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["g_entidade_id", "m_musica_id", "m_arranjador_id", "m_tonalidade_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  private

  def assign_g_entidade
    self.g_entidade_id ||= m_musica&.g_entidade_id || Current.g_usuario&.g_pessoa&.g_entidade_id
  end
end
