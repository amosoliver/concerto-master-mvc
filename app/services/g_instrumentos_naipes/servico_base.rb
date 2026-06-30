module GInstrumentosNaipes
  class ServicoBase
    attr_reader :g_instrumento_naipe, :params

    def initialize(g_instrumento_naipe:, params:)
      @g_instrumento_naipe = g_instrumento_naipe
      @params = params
    end

    private

    def assign_relations!
      g_instrumento_naipe.g_instrumento = resolve_instrumento!
      g_instrumento_naipe.g_naipe = resolve_naipe!
    end

    def resolve_instrumento!
      resolve_catalog_record!(
        model: GInstrumento,
        selected_id: params[:g_instrumento_id],
        typed_description: params[:novo_g_instrumento],
        attribute_name: :g_instrumento_id,
        label: "instrumento"
      )
    end

    def resolve_naipe!
      resolve_catalog_record!(
        model: GNaipe,
        selected_id: params[:g_naipe_id],
        typed_description: params[:novo_g_naipe],
        attribute_name: :g_naipe_id,
        label: "naipe"
      )
    end

    def resolve_catalog_record!(model:, selected_id:, typed_description:, attribute_name:, label:)
      description = typed_description.to_s.strip

      return restore_or_build_by_description(model, description) if description.present?
      return model.find(selected_id) if selected_id.present?

      g_instrumento_naipe.errors.add(attribute_name, "selecione ou cadastre um #{label}.")
      raise ActiveRecord::RecordInvalid.new(g_instrumento_naipe)
    end

    def restore_or_build_by_description(model, description)
      record = model.with_discarded.where("LOWER(descricao) = ?", description.downcase).first_or_initialize
      record.descricao = description
      record.deleted_at = nil if record.respond_to?(:deleted_at=)
      record.save!
      record
    end

    def merge_errors!(record)
      return if record == g_instrumento_naipe

      record.errors.each do |error|
        g_instrumento_naipe.errors.add(error.attribute, error.message)
      end
    end
  end
end
