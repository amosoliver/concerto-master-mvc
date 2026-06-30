class MArranjo < ApplicationRecord
  include SoftDeletable
  include Uppercasable

  attr_accessor :novo_m_arranjador

  upcases :descricao

  belongs_to :g_entidade
  belongs_to :m_musica
  belongs_to :m_tipo_arranjo, class_name: "MTipoArranjo"
  belongs_to :m_arranjador
  belongs_to :m_tonalidade

  has_many :m_arranjos_instrumentos_naipes
  has_many :g_instrumentos_naipes, through: :m_arranjos_instrumentos_naipes
  has_many_attached :audio

  before_validation :assign_g_entidade

  validates :descricao, :g_entidade, :m_musica, :m_tipo_arranjo, :m_arranjador, :m_tonalidade, presence: true

  def to_s
    descricao.presence || "#{m_musica} - #{m_arranjador}"
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["descricao", "g_entidade_id", "m_musica_id", "m_tipo_arranjo_id", "m_arranjador_id", "m_tonalidade_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  private

  def assign_g_entidade
    self.g_entidade_id ||= m_musica&.g_entidade_id || Current.g_entidade&.id || Current.g_usuario&.g_pessoa&.g_entidade_id
  end
end
