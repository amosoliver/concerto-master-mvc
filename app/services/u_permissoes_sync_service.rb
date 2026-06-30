require "set"

class UPermissoesSyncService
  ACTION_LABELS = {
    "index" => "Listar",
    "show" => "Visualizar",
    "new" => "Novo",
    "create" => "Salvar",
    "edit" => "Editar",
    "manage" => "Gerenciar",
    "update" => "Atualizar",
    "update_management" => "Atualizar gerenciamento",
    "destroy" => "Remover"
  }.freeze

  INTERNAL_CONTROLLERS_PREFIXES = %w[rails/ active_storage/ action_mailbox/ action_text/].freeze
  PUBLIC_ROUTES = Set.new(
    [
      ["home", "index"],
      ["rails/health", "show"],
      ["g_usuarios/sessions", "new"],
      ["g_usuarios/sessions", "create"],
      ["g_usuarios/sessions", "destroy"]
    ]
  ).freeze

  def self.call
    new.call
  end

  def call
    return 0 unless permissao_table_ready?

    route_permissions = permissions_from_routes
    created_or_updated = 0

    UPermissao.transaction do
      created_or_updated = sync_permissions(route_permissions)
    end

    created_or_updated
  rescue ActiveRecord::ConnectionNotEstablished, ActiveRecord::NoDatabaseError, ActiveRecord::StatementInvalid, PG::Error => error
    Rails.logger.warn("UPermissoesSyncService: sincronização ignorada (#{error.class}: #{error.message})")
    0
  end

  private

  def permissao_table_ready?
    ActiveRecord::Base.connection.data_source_exists?("u_permissoes")
  end

  def permissions_from_routes
    Rails.application.routes.routes.filter_map do |route|
      controller = route.defaults[:controller]
      action = route.defaults[:action]

      next if controller.blank? || action.blank?
      next if internal_controller?(controller)

      build_permission(controller, action)
    end.uniq { |permission| [permission[:controlador], permission[:acao]] }
  end

  def internal_controller?(controller)
    INTERNAL_CONTROLLERS_PREFIXES.any? { |prefix| controller.start_with?(prefix) } && !PUBLIC_ROUTES.include?([controller, "show"])
  end

  def build_permission(controller, action)
    {
      descricao: build_description(controller, action),
      controlador: controller,
      acao: action,
      admin: !PUBLIC_ROUTES.include?([controller, action])
    }
  end

  def build_description(controller, action)
    "#{action_label(action)} #{resource_label(controller, action)}"
  end

  def action_label(action)
    ACTION_LABELS[action] || action.humanize
  end

  def resource_label(controller, action)
    model_class = controller.classify.safe_constantize
    return model_class.model_name.human(count: resource_count_for_label(action)) if model_class&.respond_to?(:model_name)

    controller_name = controller.split("/").last
    controller_name.humanize
  end

  def resource_count_for_label(action)
    action == "index" ? 2 : 1
  end

  def sync_permissions(route_permissions)
    created_or_updated = 0

    route_permissions.each do |attributes|
      permission = UPermissao.with_discarded.find_or_initialize_by(
        controlador: attributes[:controlador],
        acao: attributes[:acao]
      )

      permission.assign_attributes(attributes.merge(deleted_at: nil))
      if permission.changed?
        permission.save!
        created_or_updated += 1
      end
    end

    created_or_updated
  end
end
