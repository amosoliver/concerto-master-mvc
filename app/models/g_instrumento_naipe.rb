class GInstrumentoNaipe < ApplicationRecord
  include SoftDeletable

  belongs_to :g_instrumento
  belongs_to :g_naipe

  has_many :g_pessoas_instrumentos
  has_many :g_pessoas, through: :g_pessoas_instrumentos
  has_many :m_arranjos_instrumentos_naipes
  has_many :m_arranjos, through: :m_arranjos_instrumentos_naipes
  has_many :m_grupos_instrumentos_naipes, class_name: "MGrupoInstrumentoNaipe"
  has_many :m_grupos, through: :m_grupos_instrumentos_naipes

  def to_s
    "#{g_instrumento} - #{g_naipe}"
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["g_instrumento_id", "g_naipe_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
