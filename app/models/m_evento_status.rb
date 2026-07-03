class MEventoStatus < ApplicationRecord
  include SoftDeletable
  include Uppercasable

  STATUS_AGENDADO = "agendado".freeze
  STATUS_EM_ANDAMENTO = "em_andamento".freeze
  STATUS_FINALIZADO = "finalizado".freeze
  STATUS_CANCELADO = "cancelado".freeze

  TODOS = {
    STATUS_AGENDADO => "Agendado",
    STATUS_EM_ANDAMENTO => "Em andamento",
    STATUS_FINALIZADO => "Finalizado",
    STATUS_CANCELADO => "Cancelado"
  }.freeze

  upcases :descricao

  has_many :m_eventos, dependent: :restrict_with_exception

  validates :codigo, presence: true, uniqueness: true
  validates :descricao, presence: true

  scope :ordered, -> { order(:descricao) }

  def self.ransackable_attributes(_auth_object = nil)
    ["codigo", "descricao", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  def self.fetch_by_codigo!(codigo)
    find_by!(codigo: codigo)
  end

  def to_s
    descricao
  end
end
