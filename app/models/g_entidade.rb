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
end
