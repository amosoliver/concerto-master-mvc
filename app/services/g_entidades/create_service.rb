module GEntidades
  class CreateService < BaseService
    def call
      assign_g_entidade_attributes

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
