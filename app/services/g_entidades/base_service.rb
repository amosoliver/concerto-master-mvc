module GEntidades
  class BaseService
    attr_reader :g_entidade, :params

    def initialize(g_entidade:, params:)
      @g_entidade = g_entidade
      @params = params
    end

    private

    def assign_g_entidade_attributes
      # fetch com o valor atual como default: se a etapa não foi visitada no
      # wizard, sua chave não existe em params e não deve apagar o valor já
      # presente no registro.
      g_entidade.assign_attributes(
        descricao: params.fetch(:descricao, g_entidade.descricao),
        g_estado_id: params.fetch(:g_estado_id, g_entidade.g_estado_id),
        g_municipio_id: params.fetch(:g_municipio_id, g_entidade.g_municipio_id),
        g_entidade_id: params.fetch(:g_entidade_id, g_entidade.g_entidade_id)
      )
    end

    def sync_grupos!
      submitted_groups = normalized_groups
      existing_groups = g_entidade.m_grupos.with_discarded.includes(:m_grupos_instrumentos_naipes).index_by(&:id)
      kept_group_ids = []

      submitted_groups.each do |group_params|
        group = existing_groups[group_params[:id]] || g_entidade.m_grupos.with_discarded.build
        group.assign_attributes(
          descricao: group_params[:descricao],
          m_tipo_grupo_id: group_params[:m_tipo_grupo_id],
          deleted_at: nil
        )
        group.save!
        kept_group_ids << group.id

        sync_grupo_instrumentos!(group, group_params[:g_instrumento_naipe_ids])
      end

      existing_groups.each_value do |group|
        next if kept_group_ids.include?(group.id)
        next if group.deleted_at.present?

        group.update!(deleted_at: Time.current)
      end
    end

    def sync_predio!
      predio_attrs = normalized_predio
      return if predio_attrs.blank?

      predio = g_entidade.g_predios.with_discarded.first_or_initialize
      predio.assign_attributes(predio_attrs.merge(g_entidade: g_entidade, deleted_at: nil))
      predio.save!
    end

    def sync_grupo_instrumentos!(group, instrumento_ids)
      target_ids = normalize_ids(instrumento_ids)
      existing_records = MGrupoInstrumentoNaipe.with_discarded.where(m_grupo_id: group.id).index_by(&:g_instrumento_naipe_id)

      target_ids.each do |instrumento_id|
        record = existing_records[instrumento_id] || MGrupoInstrumentoNaipe.new(m_grupo_id: group.id, g_instrumento_naipe_id: instrumento_id)
        record.deleted_at = nil
        record.save! if record.changed?
      end

      existing_records.each do |instrumento_id, record|
        next if target_ids.include?(instrumento_id)
        next if record.deleted_at.present?

        record.update!(deleted_at: Time.current)
      end
    end

    def normalized_groups
      Array(params[:grupos_attributes].presence || {}).to_h.values.filter_map do |group|
        next if group[:descricao].blank? && group[:m_tipo_grupo_id].blank?
        next if ActiveModel::Type::Boolean.new.cast(group[:_destroy])

        {
          id: group[:id].presence&.to_i,
          descricao: group[:descricao],
          m_tipo_grupo_id: group[:m_tipo_grupo_id],
          g_instrumento_naipe_ids: group[:g_instrumento_naipe_ids]
        }
      end
    end

    def normalized_predio
      predio = params[:predio_attributes] || {}
      return if predio.blank?

      attrs = predio.to_h.symbolize_keys.slice(:nome_fantasia, :cep, :logradouro, :bairro)
      attrs.values.all?(&:blank?) ? nil : attrs
    end

    def normalize_ids(values)
      Array(values).reject(&:blank?).map(&:to_i).uniq
    end

    def merge_errors!(record)
      return if record == g_entidade

      record.errors.full_messages.each do |message|
        g_entidade.errors.add(:base, message)
      end
    end
  end
end
