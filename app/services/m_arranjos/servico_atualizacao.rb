module MArranjos
  class ServicoAtualizacao < ServicoBase
    def call
      ActiveRecord::Base.transaction do
        assign_relations_and_attributes!
        m_arranjo.save!
        sync_relations!
      end

      m_arranjo
    rescue ActiveRecord::RecordInvalid => error
      merge_errors!(error.record)
      raise ActiveRecord::RecordInvalid.new(m_arranjo)
    end
  end
end
