module MArranjos
  class ServicoBase
    attr_reader :m_arranjo, :params

    def initialize(m_arranjo:, params:)
      @m_arranjo = m_arranjo
      @params = params
    end

    private

    def assign_relations_and_attributes!
      m_arranjo.assign_attributes(
        descricao: params[:descricao],
        m_musica_id: params[:m_musica_id],
        m_tipo_arranjo_id: params[:m_tipo_arranjo_id],
        m_tonalidade_id: params[:m_tonalidade_id]
      )
      m_arranjo.m_arranjador = resolve_arranjador!
    end

    def sync_relations!
      sync_instrumentos!
    end

    def resolve_arranjador!
      description = params[:novo_m_arranjador].to_s.strip
      return restore_or_build_by_description(MArranjador, description) if description.present?
      return MArranjador.find(params[:m_arranjador_id]) if params[:m_arranjador_id].present?

      m_arranjo.errors.add(:m_arranjador_id, "selecione ou cadastre um arranjador.")
      raise ActiveRecord::RecordInvalid.new(m_arranjo)
    end

    def sync_instrumentos!
      target_ids = normalize_ids(params[:g_instrumento_naipe_ids])
      if target_ids.empty?
        m_arranjo.errors.add(:base, "Selecione ao menos um instrumento/naipe.")
        raise ActiveRecord::RecordInvalid.new(m_arranjo)
      end

      existing_records = MArranjoInstrumentoNaipe.with_discarded.where(m_arranjo_id: m_arranjo.id).index_by(&:g_instrumento_naipe_id)

      target_ids.each do |instrumento_id|
        record = existing_records[instrumento_id] || MArranjoInstrumentoNaipe.new(m_arranjo_id: m_arranjo.id, g_instrumento_naipe_id: instrumento_id)
        record.deleted_at = nil
        record.g_entidade_id ||= m_arranjo.g_entidade_id
        record.save! if record.changed?
      end

      existing_records.each do |instrumento_id, record|
        next if target_ids.include?(instrumento_id)
        next if record.deleted_at.present?

        record.update!(deleted_at: Time.current)
      end
    end

    def restore_or_build_by_description(model, description)
      record = model.with_discarded.where("LOWER(descricao) = ?", description.downcase).first_or_initialize
      record.descricao = description
      record.deleted_at = nil if record.respond_to?(:deleted_at=)
      record.save!
      record
    end

    def normalize_ids(values)
      Array(values).reject(&:blank?).map(&:to_i).uniq
    end

    def merge_errors!(record)
      return if record == m_arranjo

      record.errors.full_messages.each do |message|
        m_arranjo.errors.add(:base, message)
      end
    end
  end
end
