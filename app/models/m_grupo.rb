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

  def to_s
    descricao
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["descricao", "g_entidade_id", "m_tipo_grupo_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
