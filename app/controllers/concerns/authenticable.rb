require "set"

module Authenticable
  extend ActiveSupport::Concern

  ACTION_LABELS = {
    "index" => "listar",
    "show" => "visualizar",
    "new" => "criar",
    "create" => "criar",
    "edit" => "editar",
    "update" => "editar",
    "destroy" => "excluir",
    "atualizar" => "atualizar permissões"
  }.freeze

  PUBLIC_PERMISSIONS = Set.new(
    [
      ["home", "index"]
    ]
  ).freeze

  included do
    helper_method :allowed_action?, :allowed_path?
  end

  private

  def authorize_current_request!
    return if allowed_action?

    redirect_to authorization_fallback_path, alert: unauthorized_message(controller_path, action_name)
  end

  def authorization_skipped?
    devise_controller? || PUBLIC_PERMISSIONS.include?([controller_path, action_name])
  end

  def allowed_action?(controller_name = controller_path, action = action_name)
    controller_name = controller_name.to_s
    action = action.to_s

    return true if devise_controller?
    return true if permissions_bootstrap_mode?
    return true if PUBLIC_PERMISSIONS.include?([controller_name, action])
    return false unless current_g_usuario

    current_g_usuario.allowed_to?(controller_name, action)
  end

  def allowed_path?(target, method: :get)
    permission = permission_from_target(target, method: method)
    return true if permission.nil?

    allowed_action?(permission[:controller], permission[:action])
  end

  def extract_link_method(html_options)
    return :get unless html_options.respond_to?(:to_h)

    options_hash = html_options.to_h
    options_hash[:method] || options_hash.dig(:data, :turbo_method) || :get
  end

  def extract_button_method(html_options)
    return :post unless html_options.respond_to?(:to_h)

    html_options.to_h[:method] || :post
  end

  def permission_from_target(target, method:)
    path =
      case target
      when String
        target
      when Hash
        url_for(target)
      else
        polymorphic_path(target)
      end

    route = Rails.application.routes.recognize_path(path_only(path), method: method.to_sym)
    return if route[:controller].blank? || route[:action].blank?

    { controller: route[:controller], action: route[:action] }
  rescue ActionController::UrlGenerationError, ActionController::RoutingError, NoMethodError
    nil
  end

  def path_only(path)
    URI.parse(path).path
  rescue URI::InvalidURIError
    path.to_s
  end

  def authorization_fallback_path
    referer = request.referer
    return root_path if referer.blank?

    referer_path = URI.parse(referer).path
    return root_path if referer_path == request.path

    referer
  rescue URI::InvalidURIError
    root_path
  end

  def unauthorized_message(controller_name, action)
    "Você não tem permissão para #{ACTION_LABELS[action.to_s] || action.to_s.humanize.downcase} #{resource_label(controller_name, action)}."
  end

  def resource_label(controller_name, action)
    model_class = controller_name.to_s.classify.safe_constantize
    return model_class.model_name.human(count: action.to_s == "index" ? 2 : 1).downcase if model_class&.respond_to?(:model_name)

    controller_name.to_s.split("/").last.humanize.downcase
  end

  def permissions_bootstrap_mode?
    @permissions_bootstrap_mode ||= GUsuario.joins(:u_perfis).distinct.none?
  end
end
