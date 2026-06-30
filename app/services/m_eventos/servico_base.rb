module MEventos
  class ServicoBase
    attr_reader :m_evento, :params

    def initialize(m_evento:, params:)
      @m_evento = m_evento
      @params = params
    end

    private

    def assign_relations_and_attributes!
      m_evento.assign_attributes(
        descricao: params[:descricao],
        data_inicio: params[:data_inicio],
        data_fim: params[:data_fim]
      )
      m_evento.g_predio = resolve_predio!
    end

    def sync_relations!
      sync_repertorio!
    end

    def resolve_predio!
      return tenant_predios.find(params[:g_predio_id]) if params[:g_predio_id].present?

      build_or_restore_predio!
    rescue ActiveRecord::RecordInvalid => error
      merge_errors!(error.record)
      m_evento.errors.add(:g_predio_id, "selecione ou cadastre um prédio.")
      raise ActiveRecord::RecordInvalid.new(m_evento)
    rescue ActiveRecord::RecordNotFound
      m_evento.errors.add(:g_predio_id, "selecione um prédio válido.")
      raise ActiveRecord::RecordInvalid.new(m_evento)
    end

    def build_or_restore_predio!
      description = params[:novo_g_predio_nome_fantasia].to_s.strip
      if description.blank?
        m_evento.errors.add(:g_predio_id, "selecione ou cadastre um prédio.")
        raise ActiveRecord::RecordInvalid.new(m_evento)
      end

      predio = GPredio.with_discarded
                      .where(g_entidade_id: current_entity_id)
                      .where("LOWER(nome_fantasia) = ?", description.downcase)
                      .first_or_initialize

      predio.assign_attributes(
        nome_fantasia: description,
        cep: params[:novo_g_predio_cep],
        logradouro: params[:novo_g_predio_logradouro],
        bairro: params[:novo_g_predio_bairro],
        latitude: params[:novo_g_predio_latitude],
        longitude: params[:novo_g_predio_longitude],
        g_entidade_id: current_entity_id,
        deleted_at: nil
      )
      predio.save!
      predio
    end

    def sync_repertorio!
      repertorio = normalized_repertorio
      existing_records = MEventoMusica.with_discarded.where(m_evento_id: m_evento.id).index_by(&:m_musica_id)

      repertorio.each do |entry|
        record = existing_records[entry[:m_musica_id]] || MEventoMusica.new(m_evento_id: m_evento.id, m_musica_id: entry[:m_musica_id])
        record.assign_attributes(
          g_entidade_id: m_evento.g_entidade_id,
          m_arranjo_id: entry[:m_arranjo_id],
          deleted_at: nil
        )
        record.save!
      end

      stale_ids = existing_records.keys - repertorio.map { |entry| entry[:m_musica_id] }
      return if stale_ids.empty?

      MEventoMusica.where(m_evento_id: m_evento.id, m_musica_id: stale_ids, deleted_at: nil).find_each(&:discard)
    end

    def normalized_repertorio
      selected_rows = repertorio_entries.filter_map do |entry|
        next unless ActiveModel::Type::Boolean.new.cast(entry[:selecionada])

        musica_id = entry[:m_musica_id].presence&.to_i
        next if musica_id.blank?

        arranjo_id = entry[:m_arranjo_id].presence
        {
          m_musica_id: resolve_musica_id!(musica_id),
          m_arranjo_id: arranjo_id.present? ? resolve_arranjo_id!(musica_id, arranjo_id.to_i) : nil
        }
      end

      selected_rows.uniq { |entry| entry[:m_musica_id] }
    end

    def repertorio_entries
      value = params[:repertorio]

      case value
      when ActionController::Parameters
        repertorio_entries_from_hash(value.to_unsafe_h)
      when Hash
        repertorio_entries_from_hash(value)
      else
        Array(value)
      end
    end

    def repertorio_entries_from_hash(value)
      value.values
    end

    def resolve_musica_id!(musica_id)
      tenant_musicas.find(musica_id).id
    rescue ActiveRecord::RecordNotFound
      m_evento.errors.add(:base, "Uma das músicas selecionadas não está disponível para a entidade atual.")
      raise ActiveRecord::RecordInvalid.new(m_evento)
    end

    def resolve_arranjo_id!(musica_id, arranjo_id)
      tenant_arranjos.where(m_musica_id: musica_id).find(arranjo_id).id
    rescue ActiveRecord::RecordNotFound
      m_evento.errors.add(:base, "O arranjo selecionado não pertence à música informada.")
      raise ActiveRecord::RecordInvalid.new(m_evento)
    end

    def tenant_predios
      GPredio.where(g_entidade_id: current_entity_ids)
    end

    def tenant_musicas
      MMusica.where(g_entidade_id: current_entity_ids)
    end

    def tenant_arranjos
      MArranjo.where(g_entidade_id: current_entity_ids)
    end

    def current_entity_id
      m_evento.g_entidade_id || Current.g_entidade&.id
    end

    def current_entity_ids
      Array(Current.g_entidade_ids).presence || Array(current_entity_id)
    end

    def merge_errors!(record)
      return if record == m_evento

      record.errors.each do |error|
        m_evento.errors.add(error.attribute, error.message)
      end
    end
  end
end
