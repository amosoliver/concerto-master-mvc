class MEnsaio < ApplicationRecord
  include SoftDeletable

  attr_accessor :m_evento_ids, :m_grupo_ids

  belongs_to :g_predio
  belongs_to :g_entidade

  has_many :m_ensaio_musicas, class_name: "MEnsaioMusica", foreign_key: :m_ensaio_id, dependent: :destroy
  has_many :m_evento_musicas, through: :m_ensaio_musicas, source: :m_evento_musica
  has_many :m_musicas, through: :m_evento_musicas
  has_many :m_ensaio_eventos, class_name: "MEnsaioEvento", foreign_key: :m_ensaio_id, dependent: :destroy
  has_many :m_eventos, through: :m_ensaio_eventos, source: :m_evento
  has_many :m_ensaio_grupos, class_name: "MEnsaioGrupo", foreign_key: :m_ensaio_id, dependent: :destroy
  has_many :m_grupos, through: :m_ensaio_grupos, source: :m_grupo

  before_validation :assign_g_entidade
  validates :descricao, :data_inicio, :data_fim, :g_predio_id, presence: true
  validate :data_fim_after_inicio
  validate :sem_conflito_com_eventos

  def self.ransackable_attributes(_auth_object = nil)
    ["descricao", "data_inicio", "data_fim", "g_predio_id", "g_entidade_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  def to_s
    descricao
  end

  def grupos_label
    return "Ensaio geral da entidade" if m_grupos.empty?

    m_grupos.map(&:descricao).join(", ")
  end

  private

  def assign_g_entidade
    self.g_entidade_id ||= g_predio&.g_entidade_id || Current.g_entidade&.id
  end

  def data_fim_after_inicio
    return if data_inicio.blank? || data_fim.blank?
    return if data_fim >= data_inicio

    errors.add(:data_fim, "deve ser maior ou igual à data inicial.")
  end

  def sem_conflito_com_eventos
    return if g_entidade_id.blank? || data_inicio.blank? || data_fim.blank?

    conflito = MEvento.where(g_entidade_id: g_entidade_id)
                      .where("COALESCE(data_inicio, data_fim) < ? AND COALESCE(data_fim, data_inicio) > ?", data_fim, data_inicio)
                      .order(:data_inicio)
                      .first
    return if conflito.blank?

    errors.add(:base, "O ensaio cruza com o evento #{conflito.descricao} em #{format('%02d/%02d/%04d %02d:%02d', conflito.data_inicio.day, conflito.data_inicio.month, conflito.data_inicio.year, conflito.data_inicio.hour, conflito.data_inicio.min)}.")
  end
end
