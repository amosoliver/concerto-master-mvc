module GPessoas
  class ServicoAtualizacao < ServicoBase
    def call
      assign_g_pessoa_attributes
      GPessoasController::STEPS.each_with_index do |step, index|
        raise ActiveRecord::RecordInvalid.new(g_pessoa) unless valid_for_step?(step, clear_errors: index.zero?)
      end

      ActiveRecord::Base.transaction do
        g_pessoa.save!
        sync_relations!
      end

      g_pessoa
    rescue ActiveRecord::RecordInvalid => error
      merge_errors!(error.record)
      raise ActiveRecord::RecordInvalid.new(g_pessoa)
    end
  end
end
