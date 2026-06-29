class ApplicationController < ActionController::Base
  include Authenticable
  include CurrentContext
  include Pagy::Method
  include TenantAccess

  before_action :authenticate_g_usuario!, unless: :devise_controller?
  before_action { Pagy::I18n.locale = "pt-BR" }
  before_action :redirect_primeiro_acesso!
  before_action :authorize_current_request!, unless: :authorization_skipped?

  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
  rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  protected

  def after_sign_in_path_for(resource)
    return edit_g_usuario_registration_path if resource.is_a?(GUsuario) && resource.primeiro_acesso?

    super
  end
  def redirect_primeiro_acesso!
    return unless g_usuario_signed_in?
    return unless current_g_usuario.primeiro_acesso?
    return if devise_controller? && controller_name == "registrations"

    redirect_to edit_g_usuario_registration_path
  end

  def handle_record_not_found(_exception)
    redirect_to safe_error_fallback_path,
                alert: "O registro que você tentou acessar não está disponível na entidade ativa."
  end

  def handle_parameter_missing(exception)
    redirect_to safe_error_fallback_path,
                alert: "Não foi possível processar a solicitação. Verifique os dados enviados e tente novamente. Campo ausente: #{exception.param}."
  end

  def handle_record_invalid(exception)
    message = exception.record&.errors&.full_messages&.to_sentence.presence || "Não foi possível salvar os dados informados."

    redirect_to safe_error_fallback_path,
                alert: message
  end

  def safe_error_fallback_path
    referer = request.referer
    return referer if referer.present? && referer_path(referer) != request.path

    collection_path_for_current_controller || root_path
  end

  def collection_path_for_current_controller
    url_for(controller: controller_path, action: :index, only_path: true)
  rescue ActionController::UrlGenerationError
    root_path
  end

  def referer_path(referer)
    URI.parse(referer).path
  rescue URI::InvalidURIError
    nil
  end
end
