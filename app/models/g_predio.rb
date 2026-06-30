class GPredio < ApplicationRecord
  include SoftDeletable
  include Uppercasable

  upcases :nome_fantasia, :logradouro, :bairro

  belongs_to :g_entidade

  has_many :m_eventos
  has_many :m_ensaios

  validates :nome_fantasia, :cep, :logradouro, :bairro, :latitude, :longitude, presence: true

  before_validation { self.cep = cep.gsub(/\D/, "") if cep.present? }
  before_validation :assign_g_entidade

  def to_s
    nome_fantasia
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["nome_fantasia", "cep", "logradouro", "bairro", "latitude", "longitude", "g_entidade_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  private

  def assign_g_entidade
    self.g_entidade_id ||= Current.g_entidade&.id
  end
end
