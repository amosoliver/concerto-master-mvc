class MPessoaFuncao < ApplicationRecord
  include SoftDeletable

  belongs_to :g_pessoa
  belongs_to :u_funcao

  def self.ransackable_attributes(_auth_object = nil)
    ["g_pessoa_id", "u_funcao_id", "principal", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
