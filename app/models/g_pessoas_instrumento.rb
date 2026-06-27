class GPessoasInstrumento < ApplicationRecord
  include SoftDeletable

  belongs_to :g_entidade
  belongs_to :g_pessoa
  belongs_to :g_instrumento_naipe

  before_validation :assign_g_entidade

  def self.ransackable_attributes(_auth_object = nil)
    ["g_entidade_id", "g_pessoa_id", "g_instrumento_naipe_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  private

  def assign_g_entidade
    self.g_entidade_id ||= g_pessoa&.g_entidade_id
  end
end
