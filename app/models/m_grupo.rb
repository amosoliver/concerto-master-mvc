class MGrupo < ApplicationRecord
  include SoftDeletable
  include Uppercasable

  upcases :descricao

  belongs_to :g_entidade
  belongs_to :m_tipo_grupo

  has_many :m_grupos_pessoas
  has_many :g_pessoas, through: :m_grupos_pessoas
  has_many :m_grupos_instrumentos_naipes, class_name: "MGrupoInstrumentoNaipe"
  has_many :g_instrumentos_naipes, through: :m_grupos_instrumentos_naipes
  has_many :m_ensaio_grupos
  has_many :m_ensaios, through: :m_ensaio_grupos
  has_many :m_evento_musica_grupos
  has_many :m_eventos_musicas, through: :m_evento_musica_grupos

  before_validation :assign_g_entidade

  validates :descricao, :m_tipo_grupo, :g_entidade, presence: true

  def to_s
    descricao
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["descricao", "g_entidade_id", "m_tipo_grupo_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  private

  def assign_g_entidade
    self.g_entidade_id ||= Current.g_entidade&.id
  end
end
