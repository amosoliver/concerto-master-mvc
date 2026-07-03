module MEventos
  class ServicoCriacao < ServicoBase
    def call
      ActiveRecord::Base.transaction do
        assign_relations_and_attributes!
        assign_default_status!
        m_evento.save!
        sync_relations!
      end

      m_evento
    rescue ActiveRecord::RecordInvalid => error
      merge_errors!(error.record)
      raise ActiveRecord::RecordInvalid.new(m_evento)
    end

    private

    def assign_default_status!
      if m_evento.has_attribute?(:m_evento_status_id) && MEventoStatus.table_exists?
        m_evento.m_evento_status ||= MEventoStatus.fetch_by_codigo!(MEvento::STATUS_AGENDADO)
      elsif m_evento.has_attribute?(:status)
        m_evento[:status] ||= MEvento::STATUS_AGENDADO
      end
    end
  end
end
