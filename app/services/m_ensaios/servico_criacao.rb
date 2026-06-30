module MEnsaios
  class ServicoCriacao < ServicoBase
    def call
      assign_attributes_and_relations!
      validate_selection!

      ActiveRecord::Base.transaction do
        m_ensaio.save!
        sync_relations!
      end

      m_ensaio
    rescue ActiveRecord::RecordInvalid => error
      merge_errors!(error.record)
      raise ActiveRecord::RecordInvalid.new(m_ensaio)
    end
  end
end
