class MGrupoPessoa < ApplicationRecord
  include SoftDeletable

  belongs_to :g_pessoa
  belongs_to :m_grupo

  def self.ransackable_attributes(_auth_object = nil)
    ["g_pessoa_id", "m_grupo_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
