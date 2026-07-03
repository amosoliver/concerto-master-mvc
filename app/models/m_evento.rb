class MEvento < ApplicationRecord
  include SoftDeletable
  include Uppercasable

  STATUS_AGENDADO = "agendado".freeze
  STATUS_EM_ANDAMENTO = "em_andamento".freeze
  STATUS_FINALIZADO = "finalizado".freeze
  STATUS_CANCELADO = "cancelado".freeze

  attr_accessor :novo_g_predio_nome_fantasia,
                :novo_g_predio_cep,
                :novo_g_predio_logradouro,
                :novo_g_predio_bairro,
                :novo_g_predio_latitude,
                :novo_g_predio_longitude

  upcases :descricao

  belongs_to :g_entidade
  belongs_to :g_predio
  belongs_to :m_evento_status, optional: true

  has_many :m_eventos_musicas, class_name: "MEventoMusica", foreign_key: :m_evento_id, dependent: :destroy
  has_many :m_musicas, through: :m_eventos_musicas
  has_many :m_ensaio_eventos, class_name: "MEnsaioEvento", foreign_key: :m_evento_id, dependent: :destroy
  has_many :m_ensaios, through: :m_ensaio_eventos, source: :m_ensaio

  before_validation :assign_g_entidade

  def to_s
    descricao
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["descricao", "data_inicio", "data_fim", "g_entidade_id", "g_predio_id", "deleted_at", "m_evento_status_id"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  def repertorio_count
    if association(:m_eventos_musicas).loaded?
      m_eventos_musicas.count { |evento_musica| evento_musica.deleted_at.nil? }
    else
      m_eventos_musicas.count
    end
  end

  def arranjos_definidos_count
    if association(:m_eventos_musicas).loaded?
      m_eventos_musicas.count { |evento_musica| evento_musica.deleted_at.nil? && evento_musica.m_arranjo_id.present? }
    else
      m_eventos_musicas.where.not(m_arranjo_id: nil).count
    end
  end

  def cancelamento_limite_em
    return if data_inicio.blank?

    data_inicio.in_time_zone.next_day.beginning_of_day
  end

  def status_codigo
    m_evento_status&.codigo.presence || legacy_status_value || STATUS_AGENDADO
  end

  def status_descricao
    m_evento_status&.descricao.presence || MEventoStatus::TODOS.fetch(status_codigo, status_codigo.humanize)
  end

  def agendado?
    status_codigo == STATUS_AGENDADO
  end

  def em_andamento?
    status_codigo == STATUS_EM_ANDAMENTO
  end

  def finalizado?
    status_codigo == STATUS_FINALIZADO
  end

  def cancelado?
    status_codigo == STATUS_CANCELADO
  end

  def cancelavel?(reference_time = Time.current)
    return false if cancelado? || finalizado? || data_inicio.blank?

    reference_time < cancelamento_limite_em
  end

  def finalizavel?
    !cancelado? && !finalizado?
  end

  def cancelar!(reference_time = Time.current)
    raise ActiveRecord::RecordInvalid.new(self) unless cancelavel?(reference_time)

    apply_status!(STATUS_CANCELADO, reference_time)
  end

  def finalizar!(reference_time = Time.current)
    raise ActiveRecord::RecordInvalid.new(self) unless finalizavel?

    apply_status!(STATUS_FINALIZADO, reference_time)
  end

  private

  def legacy_status_value
    return unless has_attribute?(:status)

    self[:status].presence
  end

  def apply_status!(codigo, reference_time = Time.current)
    attributes = { status_at: reference_time }

    if has_attribute?(:m_evento_status_id) && MEventoStatus.table_exists?
      attributes[:m_evento_status] = MEventoStatus.fetch_by_codigo!(codigo)
    elsif has_attribute?(:status)
      attributes[:status] = codigo
    end

    update!(attributes)
  end

  def assign_g_entidade
    self.g_entidade_id ||= g_predio&.g_entidade_id
  end
end
