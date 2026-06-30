module MEventos
  class ServicoCriacao < ServicoBase
    def call
      ActiveRecord::Base.transaction do
        assign_relations_and_attributes!
        m_evento.save!
        sync_relations!
      end

      m_evento
    rescue ActiveRecord::RecordInvalid => error
      merge_errors!(error.record)
      raise ActiveRecord::RecordInvalid.new(m_evento)
    end
  end
end
