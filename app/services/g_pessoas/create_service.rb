module GPessoas
  class CreateService < BaseService
    def call
      assign_g_pessoa_attributes

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
