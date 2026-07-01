class GEntidade < ApplicationRecord
  include SoftDeletable
  include Uppercasable

  upcases :descricao

  belongs_to :g_estado
  belongs_to :g_municipio
  belongs_to :g_entidade, optional: true

  has_many :g_entidades
  has_many :g_predios
  has_many :g_pessoas
  has_many :m_grupos

  validates :descricao, :g_estado, :g_municipio, presence: true

  def self_and_descendant_ids
    ids = [id]
    queue = [id]

    until queue.empty?
      parent_ids = queue.shift(100)
      child_ids = self.class.where(g_entidade_id: parent_ids).pluck(:id)
      child_ids -= ids
      ids.concat(child_ids)
      queue.concat(child_ids)
    end

    ids
  end

  def g_predio_principal
    g_predios.first
  end

  def self_and_ancestor_ids
    ids = [id]
    current_parent_id = g_entidade_id

    while current_parent_id.present?
      ids << current_parent_id
      current_parent_id = self.class.where(id: current_parent_id).pick(:g_entidade_id)
    end

    ids
  end

  validate :g_entidade_nao_pode_ser_a_propria_entidade

  def to_s
    descricao
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["descricao", "g_estado_id", "g_municipio_id", "g_entidade_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  private

  def g_entidade_nao_pode_ser_a_propria_entidade
    errors.add(:g_entidade_id, :invalid) if g_entidade_id.present? && g_entidade_id == id
  end

  validate :g_municipio_deve_pertencer_ao_estado

  def g_municipio_deve_pertencer_ao_estado
    return if g_estado.blank? || g_municipio.blank?
    return if g_municipio.g_estado_id == g_estado_id

    errors.add(:g_municipio_id, "deve pertencer ao estado selecionado")
  end
end
