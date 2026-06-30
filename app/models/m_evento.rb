class MEvento < ApplicationRecord
  include SoftDeletable
  include Uppercasable

  attr_accessor :novo_g_predio_nome_fantasia,
                :novo_g_predio_cep,
                :novo_g_predio_logradouro,
                :novo_g_predio_bairro,
                :novo_g_predio_latitude,
                :novo_g_predio_longitude

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

  private

  def assign_g_entidade
    self.g_entidade_id ||= g_predio&.g_entidade_id
  end
end
