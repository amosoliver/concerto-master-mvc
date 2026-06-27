class MGrupoPessoa < ApplicationRecord
  include SoftDeletable

  belongs_to :g_entidade
  belongs_to :g_pessoa
  belongs_to :m_grupo

  before_validation :assign_g_entidade

  def self.ransackable_attributes(_auth_object = nil)
    ["g_entidade_id", "g_pessoa_id", "m_grupo_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  private

  def assign_g_entidade
    self.g_entidade_id ||= m_grupo&.g_entidade_id || g_pessoa&.g_entidade_id
  end
end
