module MEnsaios
  class ServicoBase
    attr_reader :m_ensaio, :params

    def initialize(m_ensaio:, params:)
      @m_ensaio = m_ensaio
      @params = params
    end

    private

    def assign_attributes_and_relations!
      m_ensaio.assign_attributes(
        descricao: params[:descricao],
        data_inicio: params[:data_inicio],
        data_fim: params[:data_fim],
        g_predio_id: params[:g_predio_id]
      )

      m_ensaio.g_entidade_id ||= current_entity_id
    end

    def sync_relations!
      sync_grupos!
      sync_eventos!
      sync_repertorio!
    end

    def selected_group_ids
      @selected_group_ids ||= normalize_ids(params[:m_grupo_ids]) & tenant_grupos.ids
    end

    def selected_event_ids
      @selected_event_ids ||= normalize_ids(params[:m_evento_ids]) & tenant_eventos.ids
    end

    def selected_evento_musica_ids
      @selected_evento_musica_ids ||= normalized_repertorio.map { |entry| entry[:m_evento_musica_id] }
    end

    def normalized_repertorio
      @normalized_repertorio ||= repertorio_entries.filter_map do |entry|
        next unless ActiveModel::Type::Boolean.new.cast(entry[:selecionada])

        evento_musica_id = entry[:m_evento_musica_id].presence&.to_i
        next if evento_musica_id.blank?

        evento_musica = tenant_evento_musicas.find_by(id: evento_musica_id)
        next if evento_musica.blank?
        next unless selected_event_ids.include?(evento_musica.m_evento_id)

        {
          m_evento_musica_id: evento_musica.id,
          observacao: entry[:observacao].to_s.strip.presence
        }
      end.uniq { |entry| entry[:m_evento_musica_id] }
    end

    def repertorio_entries
      value = params[:repertorio]

      case value
      when ActionController::Parameters
        value.to_unsafe_h.values
      when Hash
        value.values
      else
        Array(value)
      end
    end

    def sync_grupos!
      existing_records = MEnsaioGrupo.with_discarded.where(m_ensaio_id: m_ensaio.id).index_by(&:m_grupo_id)

      selected_group_ids.each do |grupo_id|
        record = existing_records[grupo_id] || MEnsaioGrupo.new(m_ensaio_id: m_ensaio.id, m_grupo_id: grupo_id)
        record.g_entidade_id = m_ensaio.g_entidade_id
        record.deleted_at = nil
        record.save! if record.changed?
      end

      existing_records.each do |grupo_id, record|
        next if selected_group_ids.include?(grupo_id)
        next if record.deleted_at.present?

        record.update!(deleted_at: Time.current)
      end
    end

    def sync_eventos!
      existing_records = MEnsaioEvento.with_discarded.where(m_ensaio_id: m_ensaio.id).index_by(&:m_evento_id)

      selected_event_ids.each do |evento_id|
        record = existing_records[evento_id] || MEnsaioEvento.new(m_ensaio_id: m_ensaio.id, m_evento_id: evento_id)
        record.g_entidade_id = m_ensaio.g_entidade_id
        record.deleted_at = nil
        record.save! if record.changed?
      end

      existing_records.each do |evento_id, record|
        next if selected_event_ids.include?(evento_id)
        next if record.deleted_at.present?

        record.update!(deleted_at: Time.current)
      end
    end

    def sync_repertorio!
      existing_records = MEnsaioMusica.with_discarded.where(m_ensaio_id: m_ensaio.id).index_by(&:m_evento_musica_id)

      normalized_repertorio.each do |entry|
        record = existing_records[entry[:m_evento_musica_id]] || MEnsaioMusica.new(m_ensaio_id: m_ensaio.id, m_evento_musica_id: entry[:m_evento_musica_id])
        record.g_entidade_id = m_ensaio.g_entidade_id
        record.observacao = entry[:observacao]
        record.deleted_at = nil
        record.save! if record.changed?
      end

      existing_records.each do |evento_musica_id, record|
        next if selected_evento_musica_ids.include?(evento_musica_id)
        next if record.deleted_at.present?

        record.update!(deleted_at: Time.current)
      end
    end

    def validate_selection!
      if selected_event_ids.empty?
        m_ensaio.errors.add(:base, "Selecione ao menos um evento para o ensaio.")
      end

      if normalized_repertorio.empty?
        m_ensaio.errors.add(:base, "Selecione ao menos uma música dos eventos escolhidos.")
      end

      raise ActiveRecord::RecordInvalid.new(m_ensaio) if m_ensaio.errors.any?
    end

    def normalize_ids(values)
      Array(values).reject(&:blank?).map(&:to_i).uniq
    end

    def tenant_eventos
      MEvento.where(g_entidade_id: current_entity_ids)
    end

    def tenant_grupos
      MGrupo.where(g_entidade_id: current_entity_ids)
    end

    def tenant_evento_musicas
      MEventoMusica.includes(:m_evento, :m_musica, :m_arranjo).where(g_entidade_id: current_entity_ids)
    end

    def current_entity_id
      m_ensaio.g_entidade_id || Current.g_entidade&.id
    end

    def current_entity_ids
      Array(Current.g_entidade_ids).presence || Array(current_entity_id)
    end

    def merge_errors!(record)
      return if record == m_ensaio

      record.errors.each do |error|
        m_ensaio.errors.add(error.attribute, error.message)
      end
    end
  end
end
