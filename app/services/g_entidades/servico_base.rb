module GEntidades
  class ServicoBase
    attr_reader :g_entidade, :params

    def initialize(g_entidade:, params:)
      @g_entidade = g_entidade
      @params = params
    end

    def valid_for_step?(step, clear_errors: true)
      g_entidade.errors.clear if clear_errors

      case step
      when "dados"
        assign_g_entidade_attributes
        g_entidade.valid?
      when "predio"
        validate_predio_step
      when "grupos"
        validate_grupos_step
      else
        true
      end
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

      attrs = predio.to_h.symbolize_keys.slice(:nome_fantasia, :cep, :logradouro, :bairro, :latitude, :longitude)
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

    def validate_predio_step
      predio = build_predio_for_validation
      predio.valid?.tap do |valid|
        merge_errors!(predio) unless valid
      end
    end

    def validate_grupos_step
      submitted_groups = normalized_groups

      if submitted_groups.empty?
        g_entidade.errors.add(:base, "Informe pelo menos um grupo.")
        return false
      end

      valid = true

      submitted_groups.each_with_index do |group_params, index|
        if group_params[:descricao].blank?
          g_entidade.errors.add(:base, "Grupo #{index + 1}: descrição é obrigatória.")
          valid = false
        end

        if group_params[:m_tipo_grupo_id].blank?
          g_entidade.errors.add(:base, "Grupo #{index + 1}: tipo do grupo é obrigatório.")
          valid = false
        end

        if normalize_ids(group_params[:g_instrumento_naipe_ids]).empty?
          g_entidade.errors.add(:base, "Grupo #{index + 1}: selecione ao menos um instrumento/naipe.")
          valid = false
        end
      end

      valid
    end

    def build_predio_for_validation
      predio_attrs = normalized_predio || {}
      predio = g_entidade.g_predios.with_discarded.first_or_initialize
      predio.assign_attributes(predio_attrs.merge(g_entidade: g_entidade, deleted_at: nil))
      predio
    end
  end
end
