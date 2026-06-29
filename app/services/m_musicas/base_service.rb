module MMusicas
  class BaseService
    attr_reader :m_musica, :params

    def initialize(m_musica:, params:)
      @m_musica = m_musica
      @params = params
    end

    private

    def assign_relations_and_attributes!
      m_musica.assign_attributes(
        descricao: params[:descricao],
        url_referencia: params[:url_referencia]
      )
      m_musica.m_compositor = resolve_compositor!
      m_musica.m_artista = resolve_artista!
    end

    def resolve_compositor!
      resolve_optional_catalog_record(
        model: MCompositor,
        selected_id: params[:m_compositor_id],
        typed_description: params[:novo_m_compositor],
        attribute_name: :m_compositor_id
      )
    end

    def resolve_artista!
      resolve_catalog_record!(
        model: MArtista,
        selected_id: params[:m_artista_id],
        typed_description: params[:novo_m_artista],
        attribute_name: :m_artista_id,
        label: "artista"
      )
    end

    def resolve_catalog_record!(model:, selected_id:, typed_description:, attribute_name:, label:)
      description = typed_description.to_s.strip

      return restore_or_build_by_description(model, description) if description.present?
      return model.find(selected_id) if selected_id.present?

      m_musica.errors.add(attribute_name, "selecione ou cadastre um #{label}.")
      raise ActiveRecord::RecordInvalid.new(m_musica)
    end

    def resolve_optional_catalog_record(model:, selected_id:, typed_description:, attribute_name:)
      description = typed_description.to_s.strip

      return restore_or_build_by_description(model, description) if description.present?
      return model.find(selected_id) if selected_id.present?

      nil
    rescue ActiveRecord::RecordInvalid
      m_musica.errors.add(attribute_name, "selecione um valor válido.")
      raise ActiveRecord::RecordInvalid.new(m_musica)
    end

    def restore_or_build_by_description(model, description)
      record = model.with_discarded.where("LOWER(descricao) = ?", description.downcase).first_or_initialize
      record.descricao = description
      record.deleted_at = nil if record.respond_to?(:deleted_at=)
      record.save!
      record
    end

    def merge_errors!(record)
      return if record == m_musica

      record.errors.each do |error|
        m_musica.errors.add(error.attribute, error.message)
      end
    end
  end
end
