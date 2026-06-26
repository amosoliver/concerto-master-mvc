class MGrupoInstrumentoNaipe < ApplicationRecord
  include SoftDeletable

  self.table_name = "m_grupos_instrumentos_naipes"

  belongs_to :g_instrumento_naipe
  belongs_to :m_grupo

  def self.ransackable_attributes(_auth_object = nil)
    ["g_instrumento_naipe_id", "m_grupo_id", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
