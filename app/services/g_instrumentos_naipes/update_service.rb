module GInstrumentosNaipes
  class UpdateService < BaseService
    def call
      ActiveRecord::Base.transaction do
        assign_relations!
        g_instrumento_naipe.save!
      end

      g_instrumento_naipe
    rescue ActiveRecord::RecordInvalid => error
      merge_errors!(error.record)
      raise ActiveRecord::RecordInvalid.new(g_instrumento_naipe)
    end
  end
end
