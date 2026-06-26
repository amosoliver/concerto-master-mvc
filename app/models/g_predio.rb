class GPredio < ApplicationRecord
  include SoftDeletable
  include Uppercasable

  upcases :nome_fantasia, :logradouro, :bairro

  belongs_to :g_entidade

  has_many :m_eventos

  before_validation { self.cep = cep.gsub(/\D/, "") if cep.present? }

  def to_s
    nome_fantasia
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["nome_fantasia", "cep", "logradouro", "bairro", "g_entidade_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
