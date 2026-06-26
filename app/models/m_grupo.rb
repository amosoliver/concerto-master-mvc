class MGrupo < ApplicationRecord
  include SoftDeletable

  belongs_to :g_entidade
  belongs_to :m_tipo_grupo

  def self.ransackable_attributes(_auth_object = nil)
    ["descricao", "g_entidade_id", "m_tipo_grupo_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
