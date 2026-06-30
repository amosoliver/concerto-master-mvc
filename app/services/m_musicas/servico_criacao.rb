module MMusicas
  class ServicoCriacao < ServicoBase
    def call
      ActiveRecord::Base.transaction do
        assign_relations_and_attributes!
        m_musica.save!
      end

      m_musica
    rescue ActiveRecord::RecordInvalid => error
      merge_errors!(error.record)
      raise ActiveRecord::RecordInvalid.new(m_musica)
    end
  end
end
