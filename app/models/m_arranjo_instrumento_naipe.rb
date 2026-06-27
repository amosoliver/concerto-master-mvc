class MArranjoInstrumentoNaipe < ApplicationRecord
  include SoftDeletable

  belongs_to :g_entidade
  belongs_to :g_instrumento_naipe
  belongs_to :m_arranjo

  before_validation :assign_g_entidade

  def self.ransackable_attributes(_auth_object = nil)
    ["g_entidade_id", "g_instrumento_naipe_id", "m_arranjo_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  private

  def assign_g_entidade
    self.g_entidade_id ||= m_arranjo&.g_entidade_id
  end
end
