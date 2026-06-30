module GEntidades
  class ServicoCriacao < ServicoBase
    def call
      assign_g_entidade_attributes
      raise ActiveRecord::RecordInvalid.new(g_entidade) unless valid_for_step?("dados")
      raise ActiveRecord::RecordInvalid.new(g_entidade) unless valid_for_step?("predio")
      raise ActiveRecord::RecordInvalid.new(g_entidade) unless valid_for_step?("grupos")

      ActiveRecord::Base.transaction do
        g_entidade.save!
        sync_predio!
        sync_grupos!
      end

      g_entidade
    rescue ActiveRecord::RecordInvalid => error
      merge_errors!(error.record)
      raise ActiveRecord::RecordInvalid.new(g_entidade)
    end
  end
end
